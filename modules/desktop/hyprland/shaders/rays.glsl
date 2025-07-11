precision mediump float;
varying vec2 v_texcoord;

uniform sampler2D tex;
uniform float time;

vec2 move(vec2 tc, float t) {
    return tc * 1.10 + vec2(sin(t) * 0.5 + 0.5, 0);
}

void main() {
    int n = 256;
    vec2 lightPos = vec2(sin(time) * 0.5 + 0.5, 1.0);

    vec2 tc = v_texcoord;
    vec2 dir = lightPos - tc;
    vec4 v = vec4(1.0);
    for (int i = 0; i < n; i++) {
        vec2 pos = tc + dir * (float(i + 1) / float(n));
        vec4 c = texture2D(tex, pos);
        v *= 1.0 - exp(-float(n) * (0.015 / c));
    }
    vec4 color = texture2D(tex, tc) * v;
    gl_FragColor = color;
}
