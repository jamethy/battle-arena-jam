extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")

func _ready():
	$VBoxContainer/CharacterName.text = lobby.local_player.name

func _on_SubmitButton_pressed():
	lobby.set_player_name($VBoxContainer/CharacterName.text)
	self.hide()
