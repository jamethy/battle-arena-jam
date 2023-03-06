extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")
onready var character_name := $VBoxContainer/CharacterName
onready var character_color := $VBoxContainer/ColorSelector
onready var character_weapon := $VBoxContainer/WeaponSelector

var player_weapons = [ "PISTOL", "SHOTGUN", "MACHING GUN" ]


func _ready():
	for id in player_weapons:
		character_weapon.add_item(id)

func _on_SubmitButton_pressed():
	lobby.set_player_name(character_name.text)
	lobby.set_player_color(character_color.color)
	lobby.set_player_weapon(character_weapon.text)
	self.hide()


func _on_CharacterPopup_about_to_show():
	character_name.text = lobby.local_player.name
	character_color.color = lobby.local_player.color

	for i in range(0, character_weapon.get_item_count()):
		if character_weapon.get_item_text(i).to_upper() == lobby.local_player.weapon.to_upper():
			character_weapon.selected = i
			break
