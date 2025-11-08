shader_type canvas_item;

uniform float timeFactor = 0.2;

uniform int fade_direction : hint_enum("Left:0,Right:1,Top:2,Bottom:3") = 0;

void fragment() {
	vec2 uv;
	float mask = 0.0;
	if (fade_direction == 0) {
		mask = UV.x;
		uv = vec2(mask + TIME*timeFactor, UV.y);
	} else if (fade_direction == 1) {
		mask = 1.0 - UV.x;
		uv = vec2(mask + TIME*timeFactor, UV.y);
	} else if (fade_direction == 2) {
		mask = UV.y;
		uv = vec2(UV.x, mask + TIME*timeFactor);
	} else if (fade_direction == 3) {
		mask = 1.0 - UV.y;
		uv = vec2(UV.x, mask + TIME*timeFactor);
	}

	//vec2 uv = vec2(UV.x+TIME * timeFactor, UV.y);

	vec4 tex = texture(TEXTURE,uv);

	tex.a *= mask;

	COLOR = tex;
}
