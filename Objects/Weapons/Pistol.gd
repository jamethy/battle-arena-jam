extends Weapon


onready var _sprite := $Sprite

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if !is_network_master():
		return
	if event.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		_cooldown_timer.start()
		shoot()
