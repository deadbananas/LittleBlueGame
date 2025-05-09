shader_type canvas_item;

// Core distortion parameters
uniform float strength: hint_range(0.0, 0.1, 0.001) = 0.08;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius: hint_range(0.0, 1.0, 0.001) = 0.25;

// Visual effect parameters
uniform float aberration: hint_range(0.0, 1.0, 0.001) = 0.425;
uniform float width: hint_range(0.0, 0.1, 0.0001) = 0.04;
uniform float feather: hint_range(0.0, 1.0, 0.001) = 0.135;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
    // 1. Basic Setup
    vec2 screen_uv = SCREEN_UV;

    // 2. Fix the Stretching
    float aspect_ratio = SCREEN_PIXEL_SIZE.y/SCREEN_PIXEL_SIZE.x;
    vec2 aspect_corrected_uv = (screen_uv - vec2(0.0, 0.5)) / vec2(1.0, aspect_ratio) + vec2(0.0, 0.5);
	    // 3. Find Distance from Center
    vec2 distance_from_center = aspect_corrected_uv - center;

    // 4. Create the Ring Shape
    float distance_length = length(distance_from_center);
    float outer_edge = smoothstep(radius - feather, radius, distance_length);
    float inner_edge = smoothstep(radius - width - feather, radius - width, distance_length);
    float distortion_mask = (1.0 - outer_edge) * inner_edge;

    // 5. Calculate How Much to Bend
    vec2 distortion_direction = normalize(distance_from_center);
    vec2 distortion_offset = distortion_direction * strength * distortion_mask;

    // 6. Apply the Bend
    vec2 distorted_uv = aspect_corrected_uv - distortion_offset;
    // 7. Add Rainbow Effect
    vec2 color_separation = distortion_offset * aberration * distortion_mask;

    // 8. Put It All Together
    vec2 final_uv = mix(screen_uv, distorted_uv, distortion_mask);

    // 9. Sample Different Colors
    vec4 red_channel = texture(SCREEN_TEXTURE, final_uv + color_separation);
    vec4 base_color = texture(SCREEN_TEXTURE, final_uv);
    vec4 blue_channel = texture(SCREEN_TEXTURE, final_uv - color_separation);

    // 10. Final Color
    COLOR = vec4(
        red_channel.r,
        base_color.g,
        blue_channel.b,
        1.0
    );
}
