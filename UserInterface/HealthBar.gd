tool
extends HBoxContainer


export var health_full: Texture
export var health_empty:  Texture

# note these aren't the "source of truth", the real values are on the player
export var max_health = 5 
export var current_health = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_redraw_health_bar()
	Events.connect("player_health_change", self, "_on_player_health_change")



func _on_player_health_change(params: Dictionary):
	if params.player_id != get_tree().get_network_unique_id():
		# not for this player
		return
	max_health = params.max_value
	set_health(params.value)

func set_health(new_health: int) -> void:	
	# The clamp() function prevents the new_health from going below zero
	current_health = clamp(new_health, 0, max_health)
	_redraw_health_bar()


# Setter for max_health. We need a setter because we need to redraw the bar when
# max_health changes.
func set_max_health(new_max_health: int) -> void:
	max_health = new_max_health
	_redraw_health_bar()

func _redraw_health_bar() -> void:
	for child in get_children():
		child.queue_free()

	# We need as many nodes as there is max_health: one texture per health
	# point.
	for index in max_health:
		var heart := TextureRect.new()
		# As long as index is below or equal to health, draw a full heart.
		if index < current_health:
			heart.texture = health_full
		# When index is higher than health, draw an empty heart.
		else:
			heart.texture = health_empty

		# not completely sure why this is necessary
		# if we do not set it then the clicks don't pass to the game correctly
		heart.mouse_filter = MOUSE_FILTER_IGNORE

		add_child(heart)


