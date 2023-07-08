shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const int pixel_size = 4; //resolution must be divisible by pixel_size

void fragment() {
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);

	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;

	vec3 screen_pixel = texture(SCREEN_TEXTURE, vec2(FRAGCOORD.x, FRAGCOORD.y) / VIEWPORT_SIZE).xyz;
	ALBEDO = screen_pixel;
	if (ALBEDO.x < 0.99) {
		ALBEDO = texture(SCREEN_TEXTURE, vec2(x, y) / VIEWPORT_SIZE).xyz;
		if (ALBEDO.x > 0.99) {
			ALBEDO = screen_pixel;
		}
	}
}