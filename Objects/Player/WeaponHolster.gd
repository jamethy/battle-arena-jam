extends Area2D
class_name WeaponHolder

onready var _set_weapons_spawn_point := $WeaponSpawnPoint
onready var lobby = get_node("/root/Game/Lobby")

export var weapon_scene: PackedScene setget set_weapon

var weapon: Weapon
puppet var puppetTransform: Transform2D

var player_weapons = {
	"PISTOL":       preload("res://Objects/Weapons/Pistol.tscn"),
	"SHOTGUN":      preload("res://Objects/Weapons/Shotgun.tscn"),
	"MACHING GUN":  preload("res://Objects/Weapons/MachineGun.tscn"),
}

func shoot():
	if weapon:
		weapon.shoot()


func set_owner_id(owner_id: int):
	if weapon:
		weapon.owner_id = owner_id


func _ready():
	puppetTransform = transform

func _physics_process(_delta: float):
	if is_network_master():
		rset_unreliable("puppetTransform", transform)
	else:
		transform = puppetTransform


func set_weapon_by_name(weapon_name: String):
	weapon_name = weapon_name.to_upper()
	if not (weapon_name in player_weapons):
		weapon_name = "PISTOL"
	print("setting weapon by name: ", weapon_name)
	set_weapon(player_weapons.get(weapon_name))


func set_weapon(scene: PackedScene) -> void:
	weapon_scene = scene
	if weapon:
#		weapon.queue_free()
		pass
	if not is_inside_tree():
		yield(self,"ready")
	
	for child in _set_weapons_spawn_point.get_children():
		_set_weapons_spawn_point.remove_child(child)
	
	if weapon_scene:
		var new_weapon = scene.instance()
		assert(new_weapon is Weapon, "not a weapon")
		
		weapon = new_weapon
		weapon.set_network_master(get_network_master())
		_set_weapons_spawn_point.add_child(weapon)

