extends Control

onready var fighter_name = $HBoxContainer/FighterName
 
func init(name):
	fighter_name.text = name
