extends Control

onready var lobby = get_node("/root/Game/Lobby")
onready var players_list = $PanelContainer/MarginContainer/LobbyContainer/Players
var fighter_scene = preload("res://MainMenu/FighterContainer.tscn")

func _ready():
	update_players()
	lobby.connect("players_updated",self,"update_players")

func update_players():
	for net_id in lobby.players:
		var p = lobby.players[net_id]
		var item = fighter_scene.instance()
		players_list.add_child(item)
		item.init(p.name)
