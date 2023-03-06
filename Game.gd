extends Node

var world = null

var settings_file_name = "settings.json"
onready var main_menu = $CanvasLayer/MainMenu
onready var hud = $CanvasLayer/OnScreenUI

func _ready():
	$Lobby.game = self

	# connect automatically if arguments given
	var args = get_command_line_args()
	print("args ", args)
	if args.has("name"):
		$Lobby.set_player_name(args.name)
	if args.has("connect"):
		$Lobby.connect_to_server(args.connect)
		main_menu.hide()
	elif args.has("host"):
		$Lobby.create_server()
		main_menu.hide()
	if args.has("config"):
		settings_file_name = args.config

	load_settings()

func _input(event: InputEvent):
	if event.is_action_pressed("menu") and world:
		if main_menu.visible:
			main_menu.hide()
		else:
			main_menu.show()
	else:
		return
	# todo
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
	hud.visible = world != null

	if not world:
		main_menu.show()
		return
	
	world.name = 'world'
	add_child(world)
	main_menu.hide()


# settings storage location:
# https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#accessing-persistent-user-data-user
#  - linux: ~/.local/share/godot/app_userdata/battle-arena-jam/settings.json
#  - windows: %APPDATA%\Godot\app_userdata\battle-arena-jam\settings.json

func save_settings():
	print("Saving settings")
	var file = File.new()
	file.open("user://" + settings_file_name, File.WRITE)
	file.store_var(to_json({
		"local_player": $Lobby.local_player,
	}))
	file.close()
	
func load_settings():
	print("Reading from settings " + settings_file_name)
	var file = File.new()
	file.open("user://" + settings_file_name, File.READ)
	var file_var = file.get_var(true)
	if not file_var:
		file.close()
		return
	var data = parse_json(file_var)
	if data and "local_player" in data:
		var player_data = data["local_player"]
		for key in player_data:
			$Lobby.local_player[key] = player_data[key]
	file.close()
