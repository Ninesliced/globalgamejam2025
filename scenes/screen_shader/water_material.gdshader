shader_type canvas_item;

uniform float timeScale : hint_range(0.0001, 5.0) = 0.1;
uniform float warpAmplitude : hint_range(0.0, 0.5) = 0.05;

float rand(in vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise(in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a) * u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float texture_t = TIME * timeScale;
    vec2 texture_uv = mod(abs(vec2(
        /* Global warp */                                /* Granular warp */
        UV.x + noise(UV.xy - texture_t) * warpAmplitude,
        UV.y - noise(UV.xy + texture_t) * warpAmplitude
    )), 1.0);

    /*
    vec4 distort_vec = mix(
        texture(TEXTURE, texture_uv),
        vec4(0.0, 0.0, 0.0, 1.0),
        noise(UV + texture_t)
    );
    */
    vec4 distort_vec = texture(TEXTURE, texture_uv);

    COLOR = distort_vec;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
