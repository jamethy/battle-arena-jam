extends Control

@onready var fighter_name = $HBoxContainer/FighterName
@onready var fighter_color = $HBoxContainer/FighterColor
@onready var fighter_weapon = $HBoxContainer/FighterWeapon
 
func init(name,color,weapon):
	fighter_name.text = name
	fighter_color.color = color
	fighter_weapon.text = weapon
	
