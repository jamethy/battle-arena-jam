# NOT USED
# Currently not used in order to simplify the addon
# May be used at a later date


#tool
#class_name PaletteColor
#extends RefCounted
#
#var color: Color = Color.BLACK : set = _set_color
#var data: String = "" : set = _set_data
#var name: String = "Untitled"
#
#func _init(p_color: Color,p_name: String):
#	self.color = p_color
#	self.name = p_name
#
#
#func _set_color(p_color):
#	color = p_color
#	data = color.to_html(true)
#
#
#func _set_data(p_data):
#	data = p_data
#	color = Color(p_data)
