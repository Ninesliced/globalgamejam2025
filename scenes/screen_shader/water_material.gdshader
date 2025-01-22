shader_type canvas_item;

uniform float timeScale : hint_range(0.0001, 5.0) = 0.6;
uniform float warpAmplitude : hint_range(0.0, 0.5) = 0.01;
uniform float spectrumMultiplier : hint_range(0.0, 200.0) = 120.0;

#define PI 3.14159265359

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

float fbm(in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;

    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

vec2 swarp(in vec2 uv, in vec2 scale, in float t) {
    float w = fbm(uv * scale) * 12.0;

    return max(vec2(
        spectrumMultiplier * sin(w + t) - (spectrumMultiplier - 1.5),
        spectrumMultiplier * cos(w + t) - (spectrumMultiplier - 1.5)
    ), 0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float texture_t     = TIME * timeScale;
    vec2  texture_swarp = swarp(UV, vec2(0.2, 1.0), texture_t);

    vec2 target_uv = mod(abs(vec2(
        /* Global warp */                                 /* Granular warp */
        UV.x + noise(UV - texture_t) * warpAmplitude - (texture_swarp.x * 0.2),
        UV.y - noise(UV + texture_t) * warpAmplitude + (texture_swarp.y * 0.2)
    )), 1.0);

    vec4 distort_vec = texture(TEXTURE, target_uv);
    COLOR = distort_vec;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
