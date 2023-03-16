extends Node
# This class is used for both server and client

signal players_updated
signal connected

const PORT = 6001

## set these after instantiantion
var game: Node

# map between network host id and local players data
var players: Dictionary = {
}

var local_player: Dictionary = {
	"name": "me",
	"color": "e43b44",
	"weapon": "Pistol",
}

var player_resource = preload("res://Objects/Player/Player.tscn")

func _ready():
	# signals from SceneTree about networking
	get_tree().connect("peer_disconnected",Callable(self,"_on_network_peer_disconnected"))
	get_tree().connect("connected_to_server",Callable(self,"_on_connected_ok"))
	get_tree().connect("connection_failed",Callable(self,"_on_connected_fail"))
	get_tree().connect("server_disconnected",Callable(self,"_on_server_disconnected"))
	
	Events.connect("player_disconnected",Callable(self,"_on_player_disconnected"))

# This method just connects to the server
# It signals peer_connected to server and all clients (handled in _player_connected)
func connect_to_server(ip: String):
	print("connecting to " + ip)
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	get_tree().set_multiplayer_peer(peer)

# callback for "connected_to_server" from after the above method (connect_to_server) is successful
# It sends the client's data to everyone then load the base scene
func _on_connected_ok():
	print("connected")
	var net_id = get_tree().get_unique_id()
	local_player["network_id"] = net_id

	# tell everyone I have arrived
	rpc("register_player", local_player)

	# request to the server to send me people in lobby
	rpc_id(1, "populate_lobby")
	emit_signal("connected")


func _on_connected_fail():
	print("failed to connect to server")
	# todo, do something about it like show it on the UI

# This method creates the server and world and server player
func create_server():
	print("Creating server")
	# create server and listen on port
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	get_tree().network_peer = peer
	players[1] = local_player

# callback for "server_disconnected"
func _on_server_disconnected():
	local_player.erase("network_id")
	game.clear_world()
	receive_lobby({})

# Called remotely by a specific client
# only executed by the server
@rpc("any_peer") func populate_lobby():
	var caller_id = get_tree().get_remote_sender_id()
	if not get_tree().is_server():
		return

	rpc_id(caller_id, "receive_lobby", players)

@rpc("any_peer") func receive_lobby(lobby: Dictionary):
	players = lobby
	players[get_tree().get_unique_id()] = local_player
	emit_signal("players_updated", players)
	if game.world:
		for p in players:
			Events.local_emit("player_spawned", {
				"net_id": p,
				"data": players[p],
			})

# Signal response from SceneTree: peer_disconnected
# removes player from lobby and world
func _on_network_peer_disconnected(caller_id: int):
	# Called on all clients, including server, when a peer disconnects
	Events.emit("player_disconnected", {
		"net_id": caller_id,
	})

func _on_player_disconnected(params: Dictionary):
	players.erase(params.net_id)
	if game.world:
		game.world.remove_child(game.world.get_node(str(params.net_id)))

@rpc("any_peer", "call_local") func register_player(new_player_data: Dictionary):
	# We get id this way instead of as parameter, to prevent users from pretending to be other users
	var caller_id = get_tree().get_remote_sender_id()
	# Add him to our list
	new_player_data["network_id"] = caller_id
	players[caller_id] = new_player_data
	emit_signal("players_updated", players)
	if game.world:
		Events.local_emit("player_spawned", {
			"net_id": caller_id,
			"data": new_player_data,
		})
	
@rpc("any_peer", "call_local") func update_player_field(field, value):
	var caller_id = get_tree().get_remote_sender_id()
	players[caller_id][field] = value
	emit_signal("players_updated", players)

func set_player_name(name: String):
	local_player.name = name
	if get_tree().network_peer:
		rpc("update_player_field", "name", name)
	get_parent().save_settings()
	
func set_player_color(color: Color):
	local_player.color = color.to_html()
	if get_tree().network_peer:
		rpc("update_player_field", "color", color.to_html())
	get_parent().save_settings()

func set_player_weapon(weapon: String):
	local_player.weapon = weapon
	if get_tree().network_peer:
		rpc("update_player_field", "weapon", weapon)
	get_parent().save_settings()

@rpc("any_peer", "call_local") func load_world(resource_name):
	game.load_world(resource_name)
	for net_id in players:
		# on initial load you don't need to do rpc signal
		Events.local_emit("player_spawned", {
			"net_id": net_id,
			"data": players[net_id],
		})
