extends Control


#preload menu scenes
const ArenaLobby := preload("ArenaLobby.tscn")
const Credits := preload("Credits.tscn")

#Misc Variables
onready var screens_container := $Screens
onready var tween := $Tween

#Button Variables
onready var back_button := $BackButton
onready var character_button := $PanelContainer/MarginContainer/VBoxContainer/CharacterButton
onready var start_button := $PanelContainer/MarginContainer/VBoxContainer/StartButton
onready var join_button := $PanelContainer/MarginContainer/VBoxContainer/JoinButton
onready var credits_button := $PanelContainer/MarginContainer/VBoxContainer/CreditsButton

onready var lobby = get_node("/root/Game/Lobby")

func _ready () -> void:
	back_button.connect("pressed", self, "empty_screens")
	character_button.connect("pressed", self, "on_character_button")
	start_button.connect("pressed",self,"on_start_lobby")
	join_button.connect("pressed",self,"on_join_button")
	credits_button.connect("pressed",self,"change_scene",[Credits])

func change_scene(scene: PackedScene) -> void:
	var screen := scene.instance()
	screens_container.add_child(screen)
	screen.rect_pivot_offset = screen.rect_size / 2
	tween.interpolate_property(
		screen,
		"rect_position:x",
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
	change_scene(ArenaLobby)

func on_connect_popup_submit():
	$ConnectPopupDialog/VBoxContainer/SubmitButton.disabled = true
	lobby.connect_to_server($ConnectPopupDialog.IPAddress.text)
	lobby.connect("connected", self,"on_lobby_connected")

func on_lobby_connected():
	lobby.disconnect("connected", self, "on_lobby_connected")
	change_scene(ArenaLobby)

func on_start_lobby():
	lobby.create_server()
	change_scene(ArenaLobby)
	
