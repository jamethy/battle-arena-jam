extends Node

export var player_scene: PackedScene
export var bullet_scene: PackedScene

func _ready():
	assert(player_scene != null, 'Player Scene is not provided for "%s"' % [get_path()])
	Events.connect("player_spawned", self, "_on_player_spawned")
	Events.connect("player_died", self, "_on_player_died")
	
	assert(bullet_scene != null, 'Bullet Scene is not provided for "%s"' % [get_path()])
	Events.connect("player_fired_bullet", self, "_on_player_fired_bullet")
	
func _on_player_spawned(params: Dictionary):

	# create the player node, set node things, and add to world
	var p = player_scene.instance()
	p.set_network_master(params.net_id)
	p.name = str(params.net_id)
	p.position = world().get_node("SpawnPoint").position
	p.get_node("Camera2D").current = false
	world().add_child(p)

	# set player-specific properties - must be after adding to world
	p._set_player_color(params.data.color)
	p.holster.set_weapon_by_name(params.data.weapon)
	# todo set player name

	# move them a random direction to prevent spawning ontop of each other
	p.move_and_slide(10*Vector2(randf(), randf()))


func _on_player_died(params: Dictionary):
	var p = world().get_node(str(params.player_id))
	if p == null:
		print("no player found by id: ", params.player_id)
		return
	p.position = world().get_node("SpawnPoint").position
	# move them a random direction to prevent spawning ontop of each other
	p.move_and_slide(10*Vector2(randf(), randf()))
	p.puppetPosition = p.position
	p.puppetVelocity = Vector2()
	p.set_health(p.max_health)


func _on_player_fired_bullet(params: Dictionary):
	var bullet_count = params.count
	for index in bullet_count:
		var bullet: Bullet = bullet_scene.instance()
		bullet.global_transform = params.transform
		bullet.max_range = params.max_range
		bullet.speed = params.speed
		bullet.rotation_percision(deg2rad(params.precision))
		bullet.owner_id = params.player_id
		world().add_child(bullet)

# todo figure out better way
func world():
	return get_parent().world
