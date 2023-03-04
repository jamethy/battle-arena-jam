extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")
onready var character_name := $VBoxContainer/CharacterName
onready var character_color := $VBoxContainer/ColorSelector
onready var character_weapon := $VBoxContainer/WeaponSelector

var weapons = {
	"PISTOL":"res://Objects/Weapons/Pistol.tscn",
	"SHOTGUN":"res://Objects/Weapons/Shotgun.tscn",
	"MACHING GUN":"res://Objects/Weapons/MachineGun.tscn",
	}

func _ready():
	for id in weapons:
		character_weapon.add_item(id)

func _on_SubmitButton_pressed():
	lobby.set_player_name(character_name.text)
	lobby.set_player_color(character_color.color)
	lobby.set_player_weapon(character_weapon.text)
	self.hide()


func _on_CharacterPopup_about_to_show():
	character_name.text = lobby.local_player.name
	character_color.color = lobby.local_player.color
