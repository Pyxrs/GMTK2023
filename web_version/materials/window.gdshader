// Starfield shader v3 by Brian Smith (steampunkdemon.itch.io)
shader_type spatial;

render_mode unshaded;

uniform vec2 dimensions = vec2(114.0, 48.0);
uniform vec2 size = vec2(8.5, 2.0);
uniform sampler2D logo : filter_nearest;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float time = TIME / 2.0;
	float scale = size.x / size.y;
	float scale2 = dimensions.y / dimensions.x;
	ALBEDO = texture(logo, vec2((UV.x * scale * scale2) + time, UV.y)).rgb;
	METALLIC = 0.0;
	SPECULAR = 0.0;
	//EMISSION = ALBEDO.rgb;
}