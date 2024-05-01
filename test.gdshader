shader_type spatial;
render_mode unshaded, shadows_disabled, cull_disabled;

void vertex() {
	if (int(VERTEX.z) == VIEW_INDEX) {
		POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	} else {
		POSITION = vec4(2.0, 2.0, 2.0, 1.0);
	}
}

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
}