extends Control


#preload menu scenes
const ArenaLobby := preload("ArenaLobby.tscn")
const Credits := preload("Credits.tscn")

#Misc Variables
@onready var screens_container := $Screens
@onready var tween := $Tween

#Button Variables
@onready var back_button := $BackButton
@onready var character_button := $PanelContainer/MarginContainer/VBoxContainer/CharacterButton
@onready var start_button := $PanelContainer/MarginContainer/VBoxContainer/StartButton
@onready var join_button := $PanelContainer/MarginContainer/VBoxContainer/JoinButton
@onready var credits_button := $PanelContainer/MarginContainer/VBoxContainer/CreditsButton
@onready var connect_button := $ConnectPopupDialog/VBoxContainer/SubmitButton

@onready var lobby = get_node("/root/Game/Lobby")

func _ready () -> void:
	back_button.connect("pressed",Callable(self,"empty_screens"))
	character_button.connect("pressed",Callable(self,"on_character_button"))
	start_button.connect("pressed",Callable(self,"on_start_lobby"))
	join_button.connect("pressed",Callable(self,"on_join_button"))
	credits_button.connect("pressed",Callable(self,"change_scene_to_file").bind(Credits))
	connect_button.connect("pressed",Callable(self,"on_connect_popup_submit"))

func change_scene_to_file(scene: PackedScene) -> void:
	var screen := scene.instantiate()
	screens_container.add_child(screen)
	screen.pivot_offset = screen.size / 2
	tween.interpolate_property(
		screen,
		"position:x",
		-get_viewport_rect().size.x,
		0,
		1,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT
	)
	tween.start()
	back_button.show()

func empty_screens() -> void:
	back_button.hide()
	for child in screens_container.get_children():
		child.free()

func quit_scene() -> void:
	get_tree().quit()

func on_character_button():
	$CharacterPopup.popup()
	
func on_join_button():
	$ConnectPopupDialog.popup()

func on_connect_popup_submit():
	$ConnectPopupDialog/VBoxContainer/SubmitButton.disabled = true
	lobby.connect_to_server($ConnectPopupDialog/VBoxContainer/IPAddress.text)
	lobby.connect("connected",Callable(self,"on_lobby_connected"))

func on_lobby_connected():
	lobby.disconnect("connected",Callable(self,"on_lobby_connected"))
	$ConnectPopupDialog.hide()
	change_scene_to_file(ArenaLobby)

func on_start_lobby():
	lobby.create_server()
	change_scene_to_file(ArenaLobby)
	
