	shader_type canvas_item;

	uniform vec4 glow_color : source_color = vec4(0.3, 0.59, 1.0, 1.0);
	uniform float glow_size = 4.0;
	uniform float glow_strength = 1.0;
	uniform float pulse_interval = 3.0;
	uniform float pulse_duration = 2.5;
	uniform float pulse_thickness = 2.0; 

	void fragment() {
		vec4 tex = texture(TEXTURE, UV);
		
		vec2 offsets[8] = vec2[](
			vec2( 1.0,  0.0), vec2(-1.0,  0.0),
			vec2( 0.0,  1.0), vec2( 0.0, -1.0),
			vec2( 1.0,  1.0), vec2(-1.0,  1.0),
			vec2( 1.0, -1.0), vec2(-1.0, -1.0)
			);
			
		if (tex.a < 0.1) {
			float glow = 0.0;
			for (int i = 0; i < 8; i++) {
				vec2 offset = offsets[i] * glow_size * TEXTURE_PIXEL_SIZE;
				float sampleAlpha = texture(TEXTURE, UV + offset).a;
				glow += sampleAlpha;
			}
			glow = clamp(glow / 8.0 * glow_strength, 0.0, 1.0);
			vec4 baseGlow = vec4(glow_color.rgb, glow * glow_color.a);
			
			float pulse = fract(TIME / pulse_interval);
			float progress = step(pulse, pulse_duration / pulse_interval) * (pulse / (pulse_duration / pulse_interval));
			float pulse_radius = progress * (glow_size + pulse_thickness);
			float highlight = 0.0;
			
			for (int i = 0; i < 8; i++) {
			vec2 offset_outer = offsets[i] * pulse_radius * TEXTURE_PIXEL_SIZE;
			float sample_outer = texture(TEXTURE, UV + offset_outer).a;

			float inner_radius = max(pulse_radius - pulse_thickness, 0.0);
			vec2 offset_inner = offsets[i] * inner_radius * TEXTURE_PIXEL_SIZE;
			float sample_inner = texture(TEXTURE, UV + offset_inner).a;
				
				highlight += max(sample_outer - sample_inner, 0.0);

			}
			highlight = clamp(highlight / 8.0, 0.0, 1.0);
			
			highlight *= glow;
			
			vec4 pulseGlow = vec4(1.0, 1.0, 1.0, highlight);
			COLOR = baseGlow + vec4(pulseGlow.rgb * pulseGlow.a, pulseGlow.a);
			
			
		} else {
			COLOR = tex;
		}
	}


