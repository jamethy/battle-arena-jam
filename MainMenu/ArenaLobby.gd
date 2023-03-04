extends Control

onready var lobby = get_node("/root/Game/Lobby")
onready var players_list = $PanelContainer/MarginContainer/LobbyContainer/Players
var fighter_scene = preload("res://MainMenu/FighterContainer.tscn")

func _ready():
	update_players(lobby.players)
	lobby.connect("players_updated",self,"update_players")

func update_players(players):
	delete_children(players_list)
	for net_id in players:
		var p = players[net_id]
		var item = fighter_scene.instance()
		players_list.add_child(item)
		item.init(p.name,p.color)

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_FightButton_pressed():
	lobby.rpc("load_world", "Arena2")
