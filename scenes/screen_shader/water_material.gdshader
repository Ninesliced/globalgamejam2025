shader_type canvas_item;

uniform vec2  texture_scale = vec2(2.0, 4.0);
uniform float time_scale : hint_range(0.0001, 5.0) = 1.5;
uniform float warp_amplitude : hint_range(0.0, 0.5) = 0.03;
uniform float spectrum_multiplier : hint_range(0.0, 200.0) = 120.0;

#define PI 3.14159265358979323846

float rand(in vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

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

// Utility functions
vec3 mod289_3(vec3 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289_4(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289_4(((x * 34.0) + 1.0) * x);
}

vec4 taylor_inv_sqrt(vec4 r)
{
  // This is a rational approximation of the inverse square root
  return 1.79284291400159 - 0.85373472095314 * r;
}

// Classic Perlin 3D Noise
// Returns a float in the approximate range [-1, 1]
float perlinc(vec3 P)
{
    // 1) Calculate integer part and fractional part
    vec3 Pi0 = floor(P);    // Integer part
    vec3 Pi1 = Pi0 + vec3(1.0);
    vec3 Pf0 = fract(P);    // Fractional part
    vec3 Pf1 = Pf0 - vec3(1.0);

    // 2) Wrap the integer coords so they don't exceed 289
    Pi0 = mod289_3(Pi0);
    Pi1 = mod289_3(Pi1);

    // 3) We will have 8 permutations for (x, y, z) corners
    //    Build those corner indices
    vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
    vec4 iy = vec4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
    vec4 iz0 = vec4(Pi0.z);
    vec4 iz1 = vec4(Pi1.z);

    // 4) Compute the permutations
    vec4 ixy = permute(permute(ix) + iy);
    vec4 ixy0 = permute(ixy + iz0);
    vec4 ixy1 = permute(ixy + iz1);

    // 5) Get gradients from permutations
    //    Each corner has a gradient, stored in:
    //    g000, g100, g010, g110, g001, g101, g011, g111
    vec4 gx0 = fract(ixy0 * (1.0 / 7.0)) * 2.0 - 1.0;
    vec4 gy0 = floor(ixy0 * (1.0 / 7.0)) * (2.0 / 7.0) - 1.0;
    vec4 gz0 = 1.0 - abs(gx0) - abs(gy0);

    vec4 gx1 = fract(ixy1 * (1.0 / 7.0)) * 2.0 - 1.0;
    vec4 gy1 = floor(ixy1 * (1.0 / 7.0)) * (2.0 / 7.0) - 1.0;
    vec4 gz1 = 1.0 - abs(gx1) - abs(gy1);

    // 6) "Clamp" so negative gZ indicates we should reassign
    vec4 sz0 = step(gz0, vec4(0.0));
    vec4 sz1 = step(gz1, vec4(0.0));

    gx0 -= sz0 * (step(0.0, gx0) - 0.5);
    gy0 -= sz0 * (step(0.0, gy0) - 0.5);

    gx1 -= sz1 * (step(0.0, gx1) - 0.5);
    gy1 -= sz1 * (step(0.0, gy1) - 0.5);

    // 7) Organize the gradients per corner:
    vec3 g000 = vec3(gx0.x, gy0.x, gz0.x);
    vec3 g100 = vec3(gx0.y, gy0.y, gz0.y);
    vec3 g010 = vec3(gx0.z, gy0.z, gz0.z);
    vec3 g110 = vec3(gx0.w, gy0.w, gz0.w);
    vec3 g001 = vec3(gx1.x, gy1.x, gz1.x);
    vec3 g101 = vec3(gx1.y, gy1.y, gz1.y);
    vec3 g011 = vec3(gx1.z, gy1.z, gz1.z);
    vec3 g111 = vec3(gx1.w, gy1.w, gz1.w);

    // 8) Compute noise contributions from each corner
    vec4 norm0 = taylor_inv_sqrt(vec4(dot(g000, g000),
                                      dot(g100, g100),
                                      dot(g010, g010),
                                      dot(g110, g110)));
    g000 *= norm0.x;
    g100 *= norm0.y;
    g010 *= norm0.z;
    g110 *= norm0.w;

    vec4 norm1 = taylor_inv_sqrt(vec4(dot(g001, g001),
                                      dot(g101, g101),
                                      dot(g011, g011),
                                      dot(g111, g111)));
    g001 *= norm1.x;
    g101 *= norm1.y;
    g011 *= norm1.z;
    g111 *= norm1.w;

    // For each corner, the distance is Pf - cornerCoord
    // where cornerCoord is (0,0,0), (1,0,0), (0,1,0), etc.

    // Mix for corner x positions
    vec4 nxy0 = vec4(dot(g000, Pf0),
                   dot(g100, vec3(Pf1.x, Pf0.y, Pf0.z)),
                   dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z)),
                   dot(g110, vec3(Pf1.x, Pf1.y, Pf0.z)));

    vec4 nxy1 = vec4(dot(g001, vec3(Pf0.x, Pf0.y, Pf1.z)),
                   dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z)),
                   dot(g011, vec3(Pf0.x, Pf1.y, Pf1.z)),
                   dot(g111, vec3(Pf1.x, Pf1.y, Pf1.z)));

    // 9) Perform the fade curves
    vec3 fade_xyz = Pf0 * Pf0 * Pf0 * (Pf0 * (Pf0 * 6.0 - 15.0) + 10.0);

    // 10) Interpolate between corners
    vec4 nz = mix(nxy0, nxy1, fade_xyz.z);
    vec2 ny = mix(nz.xy, nz.zw, fade_xyz.y);
    float n = mix(ny.x, ny.y, fade_xyz.x);

    // 11) n is now in the range ~[-1,1]
    return 2.2 * n;
}

float perlin(vec2 uv, float time) {
    float fbm = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for (int i = 0; i < 4; i++) {
        fbm += amplitude * perlinc(vec3(uv * frequency, time * float(i)));
        frequency *= 2.0;
        amplitude *= 0.5;
    }

    return fbm;
}

float swarp(vec2 uv, float time) {
    return max(0.0, perlin(
        uv * 3.0,
        time * 0.2
    ) * 0.0005 - 0.0005);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float texture_t = TIME * time_scale;

    vec2 target_uv = mod(abs(vec2(
        UV.x + noise(UV - texture_t) * warp_amplitude,
        UV.y - noise(UV + texture_t) * warp_amplitude
    )), 1.0);

    float texture_swarp = swarp(UV, texture_t);

    vec2 texture_uv_r = mod(target_uv * texture_scale + swarp(UV, texture_t - 0.1), 1.0);
    vec2 texture_uv_g = mod(target_uv * texture_scale + swarp(UV, texture_t - 0.05), 1.0);
    vec2 texture_uv_b = mod(target_uv * texture_scale + swarp(UV, texture_t + 0.2), 1.0);

    vec4 base_color = texture(TEXTURE, texture_swarp * target_uv);
    vec4 distort_color = vec4(
        texture(TEXTURE, texture_uv_r).r,
        texture(TEXTURE, texture_uv_g).g,
        texture(TEXTURE, texture_uv_b).b,
        texture(TEXTURE, texture_uv_b).a
    );

    COLOR = base_color * distort_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
