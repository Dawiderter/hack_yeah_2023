shader_type canvas_item;

uniform float noise_scale : hint_range(0.01, 1.0) = 0.1;

void fragment() {
    // Get the current fragment's position in UV coordinates
    vec2 uv = FRAGCOORD / SCREEN_UV;

    // Sample noise using UV coordinates and scale
    float noise_value = noise(SCREEN_UV * noise_scale);

    // Map the noise value to yellow color intensity (darker values are more yellow)
    vec3 yellow_tint = vec3(noise_value, noise_value * 0.5, 0.0);

    // Output the final color
    COLOR = vec4(yellow_tint, 1.0);
}