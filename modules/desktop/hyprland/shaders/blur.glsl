precision mediump float;
varying vec2 v_texcoord;

uniform sampler2D tex;

float f(float x) {
    return max(0.0, 1.0 - abs(x * 4.0 - 1.0));
}

void main() {
    vec2 tc = v_texcoord;
    vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
    int n = 2;
    for (int x = -n; x <= n; x++) {
        for (int y = -n; y <= n; y++) {
            color += texture2D(tex, tc + vec2(float(x) / 500.0, float(y) / 500.0));
        }
    }
    color /= float((n * 2 + 1) * (n * 2 + 1));
    gl_FragColor = color;
}
