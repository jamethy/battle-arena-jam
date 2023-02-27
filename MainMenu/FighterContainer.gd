extends Control

onready var fighter_name = $HBoxContainer/FighterName
onready var weapon = $HBoxContainer/Weapon
 
func init(name):
	fighter_name.text = name

func _ready() -> void:
	weapon.add_item("PISTOL",-1)
	weapon.add_item("SHOTGUN",0)
