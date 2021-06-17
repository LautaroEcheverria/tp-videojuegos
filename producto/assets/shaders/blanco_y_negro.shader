shader_type canvas_item;

uniform int byn = 0;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	if (byn == 0)
	{
	    float luminance = dot(COLOR.rgb, vec3(0.33, 0.559, 0.001));
	    COLOR.rgb = vec3(luminance);
	}
}
