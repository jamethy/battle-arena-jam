extends Control


#preload menu scenes
const ArenaLobby := preload("ArenaLobby.tscn")
const JoinLobby := preload("ArenaLobby.tscn")
const Credits := preload("Credits.tscn")

#Misc Variables
onready var screens_container := $Screens
onready var tween := $Tween

#Button Variables
onready var back_button := $BackButton
onready var start_button := $PanelContainer/MarginContainer/VBoxContainer/StartButton
onready var join_button := $PanelContainer/MarginContainer/VBoxContainer/JoinButton
onready var credits_button := $PanelContainer/MarginContainer/VBoxContainer/CreditsButton

func _ready () -> void:
	back_button.connect("pressed", self, "empty_screens")
	start_button.connect("pressed",self,"change_scene",[ArenaLobby])
	join_button.connect("pressed",self,"change_scene",[JoinLobby])
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
