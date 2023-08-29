shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D distortion_texture;

// Blurs the screen in the X-direction.
void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(distortion_texture, UV).r * 0.02;
	vec3 col = texture(screen_texture, distortedUV).xyz;
	float gamma = 5.0;
	float brightness = ((col.r * 0.299 + col.g * 0.58 + col.b * 0.114) / 3.0) * gamma;
	vec3 gray_scale = vec3(col.r * 7.0, brightness, brightness);
	COLOR.xyz = gray_scale;
}