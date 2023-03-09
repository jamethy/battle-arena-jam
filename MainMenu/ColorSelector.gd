extends GridContainer

var color := Color.white

func _on_ColorSwatch_pressed(c: Color) -> void:
	color = c
