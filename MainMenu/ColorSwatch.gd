@tool
extends Button
class_name ColorSwatch

@onready var color_rect : ColorRect = $ColorRect

@export var color : = Color ('ffffff') : set = set_color

func set_color(value:Color) -> void:
	color = value
	if not color_rect:
		return
	color_rect.color = value
	
func _ready() -> void:
	self.color = color
	self.connect("pressed",Callable(get_parent(),"_on_ColorSwatch_pressed").bind(color))
