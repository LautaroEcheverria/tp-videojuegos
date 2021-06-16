shader_type canvas_item;

uniform int color_activado = 0;
void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	vec3 color_ant = COLOR.rgb;
	if (color_activado == 0)
	{
	    float luminance = dot(COLOR.rgb, vec3(0.33, 0.559, 0.001));
	    COLOR.rgb = vec3(luminance);
	}
	else if(color_activado == 1){
		COLOR.rgb = color_ant;
	}
}