extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")
onready var character_name := $VBoxContainer/ColorLabel
onready var character_color := $VBoxContainer/ColorSelector

func _on_SubmitButton_pressed():
	lobby.set_player_name(character_name.text)
	lobby.set_player_color(character_color.color)
	#lobby.
	self.hide()


func _on_CharacterPopup_about_to_show():
	character_name.text = lobby.local_player.name
	character_color.color = lobby.local_player.color
