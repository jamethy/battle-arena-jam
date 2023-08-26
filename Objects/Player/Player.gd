extends KinematicBody2D
class_name Player

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sprite = $Sprite
onready var hurt_box = $CollisionShape2D

onready var lobby = get_node("/root/Game/Lobby")
onready var holster = $WeaponHolster

export var max_health = 5 
export var current_health = 5

export var max_action = 5
export var current_action = 5

export var MOTION_SPEED = 250 # Pixels/second.

puppet var puppetPosition: Vector2
puppet var puppetVelocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	puppetPosition = position
	puppetVelocity = Vector2.ZERO
	$Camera2D.current = is_network_master()
	Events.connect("player_hit_by_bullet", self, "_on_player_hit_by_bullet")
	Events.connect("player_item_pickup",self,"item_pickup")

func _set_player_color (color: Color) -> void:
	sprite.material.set("shader_param/new_colour",color)

func _on_player_hit_by_bullet(params: Dictionary):
	if params.player_id != get_network_master():
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

# from KinematicBody2D
func _physics_process(_delta: float):
	var velocity: Vector2
	if is_network_master():
		velocity = get_action_iso_direction() * MOTION_SPEED
		rset_unreliable("puppetPosition", position)
		rset_unreliable("puppetVelocity", velocity)
		$WeaponHolster.look_at(get_global_mouse_position())
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
	
func _process(delta):
	if !is_network_master() && puppetVelocity.length_squared() > 0:
		position += delta * puppetVelocity

func _unhandled_input(event: InputEvent) -> void:
	if !is_network_master():
		return
	if event.is_action_pressed("shoot"):
		$WeaponHolster.shoot()
	if event.is_action_pressed("dodge"):
		action_dodge()

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

func action_dodge():
	var action_cooldown = $ActionCooldown
	if current_action > 0:
		sprite.visible = false
		hurt_box.disabled = true
		action_cooldown.start()
		set_action(current_action - 1)
		print(current_action)
	else :
		print("no action")
		
func set_action(new_action: int):
	current_action = clamp(new_action, 0, max_action)
	Events.emit("player_action_change", {
		"player_id": int(name),
		"value": current_action,
		"max_value": max_action,
	})

func _on_ActionCooldown_timeout():
	if current_action < max_action:
		set_action(current_action + 1)
		print(current_action)
		sprite.visible = true
		hurt_box.disabled = false
	else:
		pass

func item_pickup(params: Dictionary):
	if params.player_id != get_network_master():
		print("not for this player")
		return
	holster.set_weapon_by_name(params.item_name)
	

#func ghost_mode():
#	sprite.visible = false
#	hurt_box.disabled = true
