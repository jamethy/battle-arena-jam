extends CharacterBody2D
class_name Player

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D

@onready var lobby = get_node("/root/Game/Lobby")
@onready var holster = $WeaponHolster

@export var max_health = 5 
@export var current_health = 5

@export var MOTION_SPEED = 250 # Pixels/second.

var puppetPosition: Vector2
var puppetVelocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	puppetPosition = position
	puppetVelocity = Vector2.ZERO
	$Camera2D.current = is_multiplayer_authority()
	Events.connect("player_hit_by_bullet",Callable(self,"_on_player_hit_by_bullet"))

func _set_player_color (color: Color) -> void:
	sprite.material.set("shader_param/new_colour",color)

func _on_player_hit_by_bullet(params: Dictionary):
	if params.player_id != get_multiplayer_authority():
		# not for this player
		return
	set_health(current_health - params.damage)
	if current_health == 0:
		Events.emit("player_died", {
			"player_id": int(name),
			"killer_id": params.damage_doer,
		})

func set_health(new_health: int):
	current_health = clamp(new_health, 0, max_health)
	Events.emit("player_health_change", {
		"player_id": int(name),
		"value": current_health,
		"max_value": max_health,
	})
	
@rpc
func _set_telem(pos, vel):
	puppetPosition = pos
	puppetVelocity = vel

# from CharacterBody2D
func _physics_process(_delta: float):
	var velocity: Vector2
	if is_multiplayer_authority():
		velocity = get_action_iso_direction() * MOTION_SPEED
		rpc("_set_telem", position, velocity)
		$WeaponHolster.look_at(get_global_mouse_position())
	else:
		velocity = puppetVelocity
		position = puppetPosition
	
	if velocity.length_squared() > 0:
		set_velocity(velocity)
		move_and_slide()
		animation_state.travel("Run")
	else :
		animation_state.travel("Idle")
	
	#Set animation 2dblend space based on normalied velocity
	var nVel = velocity.normalized()
	animation_tree.set ('parameters/Idle/blend_position', nVel)
	animation_tree.set ('parameters/Run/blend_position', nVel)
	
func _process(delta):
	if !is_multiplayer_authority() && puppetVelocity.length_squared() > 0:
		position += delta * puppetVelocity

func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	if event.is_action_pressed("shoot"):
		$WeaponHolster.shoot()
		
	
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
