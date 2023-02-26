extends Control

onready var character_name = $PanelContainer/MarginContainer/CharacterPopup
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_name.show()

func set_character() ->void:
	
