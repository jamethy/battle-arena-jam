extends GridContainer



var color := Color.white


# Called when the node enters the scene tree for the first time.
func _ready():

	for swatch in get_children():
		swatch.connect("pressed", self, "_on_ColorSwatch_pressed", [color])


func _on_ColorSwatch_pressed(color_string: String) -> void:
	color = Color(color_string)
