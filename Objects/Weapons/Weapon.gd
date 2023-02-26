class_name Weapon
extends Node2D

#exports Bullet scene
export var bullet_scene: PackedScene

#weapon Stats
export var fire_rate := 2
#random angle in degrees for gun accuacy
export (float, 0.0, 360.0, 1.0) var gun_percision := 10.0
export (float, 100.0, 2000.0, 1.0) var bullet_range := 1000.0
export (float, 100.0, 3000.0, 1.0) var bullet_speed := 500.0

onready var _cooldown_timer := $CoolDownTimer

func _ready() -> void:
	assert(bullet_scene != null, 'Bullet Scene is not provided for "%s"' % [get_path()])
	_cooldown_timer.wait_time = 1.0 / fire_rate


func shoot() -> void:
	var bullet: Bullet = bullet_scene.instance()
	get_tree().root.add_child(bullet)
	bullet.global_transform = global_transform
	bullet.max_range = bullet_range
	bullet.speed = bullet_speed
	bullet.rotation_percision(deg2rad(gun_percision))
