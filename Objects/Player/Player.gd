extends KinematicBody2D
class_name Player

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sprite = $Sprite

onready var lobby = get_node("/root/Game/Lobby")


export var MOTION_SPEED = 250 # Pixels/second.

puppet var puppetPosition: Vector2
puppet var puppetVelocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	puppetPosition = position
	puppetVelocity = Vector2.ZERO
	$Camera2D.current = is_network_master()
	Events.connect("player_hit_by_bullet", self, "_on_player_hit_by_bullet")
	
	_set_player_color(lobby.players[get_network_master()].color)
	

func _set_player_color (color: Color) -> void:
	sprite.material.set("shader_param/new_colour",color)

func _on_player_hit_by_bullet(params: Dictionary):
	if params.player_id != int(name):
		# not for this player
		return
	print("player hurt")

# from KinematicBody2D
func _physics_process(delta: float):
	var velocity: Vector2
	if is_network_master():
		velocity = get_action_iso_direction() * MOTION_SPEED
		rset_unreliable("puppetPosition", position)
		rset_unreliable("puppetVelocity", velocity)
	else:
		velocity = puppetVelocity
		position = puppetPosition
	
	if velocity.length_squared() > 0:
		move_and_slide(velocity)
		animation_state.travel("Run")
	else :
		animation_state.travel("Idle")
	
	#Set animation 2dblend space based on normalied velocity
	var nVel = velocity.normalized()
	animation_tree.set ('parameters/Idle/blend_position', nVel)
	animation_tree.set ('parameters/Run/blend_position', nVel)
	

	
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
