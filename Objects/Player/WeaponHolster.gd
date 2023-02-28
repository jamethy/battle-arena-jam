extends Area2D

export var weapon_scene: PackedScene setget set_weapon

var weapon: Weapon
puppet var puppetTransform: Transform2D

onready var _set_weapons_spawn_point := $WeaponSpawnPoint


func _ready():
	puppetTransform = transform

func _physics_process(_delta: float):
		
	if is_network_master():
		# This function makes the node rotate towards the mouse
		look_at(get_global_mouse_position())
		rset_unreliable("puppetTransform", transform)
	else:
		transform = puppetTransform
	


func set_weapon(scene: PackedScene) -> void:
	weapon_scene = scene
	if weapon:
		weapon.queue_free()
		
	if not is_inside_tree():
		yield(self,"ready")
	
	if weapon_scene:
		var new_weapon = scene.instance()
		assert(new_weapon is Weapon, "not a weapon")
		
		weapon = new_weapon
		weapon.set_network_master(get_network_master())
		_set_weapons_spawn_point.add_child(weapon)

