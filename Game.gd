extends Node


func _ready():
	$Lobby.game = self

	# connect automatically if arguments given
	var args = get_command_line_args()
	if args.has("name"):
		$Lobby.set_player_name(args.name)
	if args.has("connect"):
		$Lobby.connect_to_server(args.connect)
		$MainMenu.hide()
	elif args.has("host"):
		$Lobby.create_server()
		$MainMenu.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("menu"):
		if $MainMenu.visible:
			$MainMenu.hide()
		else:
			$MainMenu.show()
	else:
		return
	get_tree().set_input_as_handled()

static func get_command_line_args() -> Dictionary:
	var arguments = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	return arguments
