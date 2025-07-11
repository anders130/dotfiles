precision mediump float;
varying vec2 v_texcoord;

uniform sampler2D tex;
uniform float time;

vec2 move(vec2 tc, float t) {
    return tc * 1.10 + vec2(sin(t) * 0.5 + 0.5, 0);
}

void main() {
    vec2 tc = v_texcoord;
    vec2 middle = vec2(0.5, 0.5);
    float dist = length(tc - middle);
    tc = (tc - middle) * (1.0 + pow(dist,8.0) * 10000.0) + middle;
    tc = fract(tc);

    vec3 shift = vec3(0.001, 0.005, 0.009);
    int n = 2;

    vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
    for (int i = 0; i < n; i++) {
        float v = float(i + 1);
        float r = texture2D(tex, (tc - middle) * (1.0 + shift.r * v) + middle).r;
        float g = texture2D(tex, (tc - middle) * (1.0 + shift.g * v) + middle).g;
        float b = texture2D(tex, (tc - middle) * (1.0 + shift.b * v) + middle).b;
        color += vec4(r, g, b, 1.0);
    }
    color /= float(n);

    // vec4 color = texture2D(tex, tc);
    color.rgb += sin(tc.y * 600.0 - 100.0 * time) * 0.1;
    color.r *= 0.5;
    color.b *= 0.5;
    color.g *= 1.5;;
    gl_FragColor = color;
}
