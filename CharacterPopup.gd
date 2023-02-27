extends WindowDialog

onready var lobby = get_node("/root/Game/Lobby")

func _ready():
	$VBoxContainer/CharacterName.text = lobby.local_player.name
	#$VBoxContainer/ColorSelector.color = lobby.local_player.color

func _on_SubmitButton_pressed():
	lobby.set_player_name($VBoxContainer/CharacterName.text)
	self.hide()
