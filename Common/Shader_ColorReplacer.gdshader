shader_type canvas_item;

uniform vec4 select_colour : source_color;
uniform vec4 new_colour : source_color;

void fragment(){
    COLOR = texture(TEXTURE, UV);
    if(distance(COLOR, select_colour) < 0.1)
        COLOR = new_colour;
}