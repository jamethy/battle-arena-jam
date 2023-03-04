extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")
onready var character_name := $VBoxContainer/CharacterName
onready var character_color := $VBoxContainer/ColorSelector
onready var character_weapon := $VBoxContainer/WeaponSelector

var weapons = {
	-1: {"name":"Pistol",
		"scene":"res://Objects/Weapons/Pistol.tscn"
	},
	0: {"name":"Shotgun",
		"scene":"res://Objects/Weapons/Shotgun.tscn"
	},
	1: {"name":"Machine Gun",
		"scene":"res://Objects/Weapons/MachineGun.tscn"
	},
}

#func _ready():
#	for id in weapons:
#		character_weapon.add_item()

func _on_SubmitButton_pressed():
	lobby.set_player_name(character_name.text)
	lobby.set_player_color(character_color.color)
	#lobby.
	self.hide()


func _on_CharacterPopup_about_to_show():
	character_name.text = lobby.local_player.name
	character_color.color = lobby.local_player.color
