tool
extends HBoxContainer


export var health_full: Texture
export var health_empty:  Texture

export var max_health = 5 
export var current_health = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_redraw_health_bar()

func set_health(new_health: int) -> void:	# The clamp() function prevents the new_health from going 
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
		add_child(heart)

