extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")

func _on_SubmitButton_pressed():
	lobby.set_player_name($VBoxContainer/CharacterName.text)
	self.hide()


func _on_CharacterPopup_about_to_show():
	$VBoxContainer/CharacterName.text = lobby.local_player.name
