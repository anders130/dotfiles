precision mediump float;
varying vec2 v_texcoord;

uniform sampler2D tex;
uniform float time;

void main() {
    vec2 tc = v_texcoord;
    vec2 middle = vec2(sin(1.0 * time) * 0.5 + 0.5, cos(1.0 * time) * 0.5 + 0.5);
    vec3 shift = vec3(0.001, 0.005, 0.009) * (sin(time) * 0.5 - 0.5) * 100.0;
    int n = 16;

    vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
    for (int i = 0; i < n; i++) {
        float v = float(i + 1);
        float r = texture2D(tex, (tc - middle) * (1.0 + shift.r * v) + middle).r;
        float g = texture2D(tex, (tc - middle) * (1.0 + shift.g * v) + middle).g;
        float b = texture2D(tex, (tc - middle) * (1.0 + shift.b * v) + middle).b;
        color += vec4(r, g, b, 1.0);
    }
    color /= float(n);
    gl_FragColor = color;
}
