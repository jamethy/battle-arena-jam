extends Node

var world = null

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

func load_world(new_world_name):
	print("loading world: " + new_world_name)
	var new_world = load("res://Scenes/" + new_world_name + ".tscn").instance()
	if not new_world:
		print("unable to load new world")
		return
	
	var old_world = world

	if old_world:
		remove_child(old_world)
		old_world.queue_free()

	world = new_world
	if not world:
		$MainMenu.show()
		return
	
	world.name = 'world'
	add_child(world)
	$MainMenu.hide()
