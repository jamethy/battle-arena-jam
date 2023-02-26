extends Area2D



func _physics_process(_delta: float):
	# This function makes the node rotate towards the mouse
	look_at(get_global_mouse_position())
