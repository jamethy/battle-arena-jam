class_name Weapon
extends Node2D

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

#weapon Stats
@export var weapon_name : String = "Weapon Name"
@export_range (0.25, 10, 0.25) var fire_rate := 2.0
#random angle in degrees for gun accuacy
@export_range (0.0, 360.0, 1.0) var gun_percision := 10.0
@export_range (100.0, 2000.0, 10.0) var bullet_range := 1000.0
@export_range (100.0, 3000.0, 10.0) var bullet_speed := 500.0
@export_range (1.0, 5.0, 1.0) var bullet_count := 1.0
@export_range (1.0, 24.0, 1.0) var clip_size := 5.0
@export_range (1.0, 24.0, 1.0) var current_clip_size := clip_size
@export_range (0.25, 4.0, 0.25) var reload_time := 0.50

@onready var _cooldown_timer := $CoolDownTimer

@onready var owner_id := get_multiplayer_authority()

func _ready() -> void:
	_cooldown_timer.wait_time = 1.0 / fire_rate

func shoot() -> void:
	if not _cooldown_timer.is_stopped():
		return 
	if current_clip_size > 0:
		animation_state.travel("Shoot")
		_cooldown_timer.start()
		# picked up by bullet spawner
		Events.emit("player_fired_bullet", {
			"player_id": owner_id,
			"transform": global_transform,
			"max_range": bullet_range,
			"speed": bullet_speed,
			"precision": gun_percision,
			"count": bullet_count,
		})
		current_clip_size -= 1
		print(current_clip_size)
	if current_clip_size <= 0:
		reload()

func reload() -> void:
	await get_tree().create_timer(reload_time).timeout
	current_clip_size = clip_size
	print("weapon reloaded")
