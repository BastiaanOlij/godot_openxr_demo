shader_type canvas_item;

uniform float layer = 0;
uniform sampler2DArray xr_texture : source_color;

void fragment() {
	COLOR.rgb = texture(xr_texture, vec3(UV, layer)).rgb;
	COLOR.a = 1.0;
}
