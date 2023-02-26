class_name Weapon
extends Node2D

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

#weapon Stats
export (float, 0.25, 10, 0.25) var fire_rate := 2.0
#random angle in degrees for gun accuacy
export (float, 0.0, 360.0, 1.0) var gun_percision := 10.0
export (float, 100.0, 2000.0, 10.0) var bullet_range := 1000.0
export (float, 100.0, 3000.0, 10.0) var bullet_speed := 500.0

onready var _cooldown_timer := $CoolDownTimer

func _ready() -> void:
	_cooldown_timer.wait_time = 1.0 / fire_rate

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var mouse_pos_normal = mouse_pos.normalized()
	animation_tree.set ('parameters/Idle/blend_position', mouse_pos_normal)
	animation_tree.set ('parameters/Shoot/blend_position', mouse_pos_normal)

func shoot() -> void:
	#animation_state.travel("Shoot")#
	# picked up by bullet spawner
	Events.emit("player_fired_bullet", {
		"player_id": get_tree().get_network_unique_id(),
		"transform": global_transform,
		"max_range": bullet_range,
		"speed": bullet_speed,
		"precision": gun_percision,
	})

func idle() -> void:
	pass
