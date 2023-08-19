tool
extends HBoxContainer


export var action_full: Texture
export var action_empty:  Texture

# note these aren't the "source of truth", the real values are on the player
export var max_action = 5 
export var current_action = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_redraw_action_bar()
	Events.connect("player_action_change", self, "_on_player_action_change")

func _on_player_action_change(params: Dictionary):
	if params.player_id != get_tree().get_network_unique_id():
		# not for this player
		return
	max_action = params.max_value
	set_action(params.value)

func set_action(new_action: int) -> void:	
	# The clamp() function prevents the new_health from going below zero
	current_action = clamp(new_action, 0, max_action)
	_redraw_action_bar()


# Setter for max_health. We need a setter because we need to redraw the bar when
# max_health changes.
func set_max_action(new_max_action: int) -> void:
	max_action = new_max_action
	_redraw_action_bar()

func _redraw_action_bar() -> void:
	for child in get_children():
		child.queue_free()

	# We need as many nodes as there is max_health: one texture per health
	# point.
	for index in max_action:
		var gem := TextureRect.new()
		# As long as index is below or equal to health, draw a full heart.
		if index < current_action:
			gem.texture = action_full
		# When index is higher than health, draw an empty heart.
		else:
			gem.texture = action_empty

		# not completely sure why this is necessary
		# if we do not set it then the clicks don't pass to the game correctly
		gem.mouse_filter = MOUSE_FILTER_IGNORE

		add_child(gem)

