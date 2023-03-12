extends Node

var world = null

var settings_file_name = "settings.json"
onready var main_menu = $CanvasLayer/MainMenu
onready var hud = $CanvasLayer/OnScreenUI

func _ready():
	$Lobby.game = self

	var args = get_command_line_args()

	if args.has("config"):
		settings_file_name = args.config
	load_settings()

	if args.has("connect"):
		$Lobby.connect_to_server(args.connect)
		$Lobby.connect("connected", self,"_on_lobby_connected_by_args")
	elif args.has("host"):
		main_menu.on_start_lobby()
		$Lobby.rpc("load_world", "Arena2")
		main_menu.hide()

func _on_lobby_connected_by_args():
	main_menu.change_scene(main_menu.ArenaLobby)
	$Lobby.disconnect("connected", self,"_on_lobby_connected_by_args")
	$Lobby.load_world("Arena2")
	main_menu.hide()

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
		if !argument.begins_with('--'):
			continue
		argument = argument.lstrip("--")
		if "=" in argument:
			var key_value = argument.split("=", false, 2)
			arguments[key_value[0]] = key_value[1]
		else:
			arguments[argument] = true
	return arguments
	

func clear_world():
	remove_child(world)
	world.queue_free()
	hud.visible = false
	main_menu.show()

func load_world(new_world_name):
	print("loading world: " + new_world_name)
	var new_world = load("res://Scenes/" + new_world_name + ".tscn").instance()
	if not new_world:
		print("unable to load new world")
		return
	
	clear_world()

	world = new_world

	if not world:
		return
	
	world.name = 'world'
	add_child(world)
	hud.visible = true
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
