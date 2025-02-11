shader_type canvas_item;

// repeating pattern
uniform vec2 tiling_density = vec2(1.0, 1.0);
uniform vec2 scrolling_dir = vec2(1.0,0.0);
uniform vec2 oscilation_speed = vec2(0,1.0);
uniform vec2 oscilation_amp = vec2(1.0,1.0);
varying flat vec4 modulate;


void fragment() {
	// repeating patter
	modulate = COLOR;
    // Calculate texture coordinates based on the screen position
    // and the tiling density, which affects the amount of repetition.
    vec2 uv_1 = UV * tiling_density;
	//vec2 uv_2 = vec2(uv_1.x*TIME, uv_1.y);
    // Fetch the texture color at the modified UV coordinates
    //COLOR.rgba = texture(TEXTURE, uv_1).rgba;
	
	vec2 uv = vec2(	uv_1.x + oscilation_amp.x*cos(TIME*oscilation_speed.x) + TIME*scrolling_dir.x,
		 			uv_1.y + oscilation_amp.y*cos(TIME*oscilation_speed.y) + TIME*scrolling_dir.y);
	
	COLOR.rgba = texture(TEXTURE, uv).rgba;
	
	//COLOR = COLOR*modulate;
	
}

