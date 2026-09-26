precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

vec3 adjustSaturation(vec3 color, float saturation) {
    const vec3 luminanceWeight = vec3(0.2126, 0.7152, 0.0722);
    float luminance = dot(color, luminanceWeight);
    return mix(vec3(luminance), color, saturation);
}

void main() {
    vec2 uv = v_texcoord;

vec2 wave = vec2(
        sin(uv.y * 12.0 + uv.x * 6.0) * 0.015,
        cos(uv.x * 12.0 + uv.y * 6.0) * 0.015
    );
    vec2 uv_distorted = uv + wave;

    float shift = 0.012;
    float r = texture2D(tex, uv_distorted + vec2(shift, 0.0)).r;
    float g = texture2D(tex, uv_distorted).g;
    float b = texture2D(tex, uv_distorted - vec2(shift, 0.0)).b;
    vec3 color = vec3(r, g, b);

    color = adjustSaturation(color, 1.8);

    vec3 neon_magenta = vec3(0.9, 0.1, 0.6);
    vec3 neon_violet  = vec3(0.4, 0.0, 0.9);
    vec3 neon_cyan    = vec3(0.0, 0.8, 1.0);

    float gradient_pos = sin((uv.x + uv.y) * 4.0) * 0.5 + 0.5;
    vec3 liquid_color = mix(neon_magenta, mix(neon_violet, neon_cyan, gradient_pos), gradient_pos);

    color = mix(color, color + liquid_color * 0.8, 0.5);

    float glass_reflection = pow(max(0.0, 1.0 - length(uv - vec2(0.3, 0.2)) * 1.2), 3.0) * 0.35;
    color += vec3(glass_reflection);

    gl_FragColor = vec4(color, 1.0);
}
