extends KinematicBody2D

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

export var MOTION_SPEED = 250 # Pixels/second.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# from KinematicBody2D
func _physics_process(delta: float):
	if !is_network_master():
		return
	var input_dir = get_action_iso_direction()
	if input_dir.length_squared() > 0:
		var velocity: Vector2 = input_dir * MOTION_SPEED
		move_and_slide(velocity)
		animation_state.travel("Run")
	else :
		animation_state.travel("Idle")
	
	animation_tree.set ('parameters/Idle/blend_position', input_dir.normalized())
	animation_tree.set ('parameters/Run/blend_position', input_dir.normalized())
	

	
static func get_action_iso_direction() -> Vector2:
	var left := Input.get_action_strength("move_left")
	var right := Input.get_action_strength("move_right")
	var up := Input.get_action_strength("move_up")
	var down := Input.get_action_strength("move_down")

	var dir := Vector2.ZERO
	dir.x = right - left
	dir.y = down - up
	dir.y /= 2
	return dir.normalized()
