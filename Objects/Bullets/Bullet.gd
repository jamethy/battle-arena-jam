class_name Bullet
extends Area2D


export var speed := 750.0
export var damage := 1
export var max_range := 1000.0

var _travelled_distance: float = 0

func _physics_process(delta: float) -> void:
	_move(delta)

func rotation_percision(max_angle: float) -> void:
	rotation += randf() * max_angle - max_angle / 2.0

func _move(delta:float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta

	position += motion

	_travelled_distance += distance
	if _travelled_distance > max_range:
		_destroy()
	
func _destroy() ->void:
	queue_free()
