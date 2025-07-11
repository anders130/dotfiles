precision mediump float;
varying vec2 v_texcoord;

uniform float time;
uniform sampler2D tex;

float f(float x) {
    return max(0.0, 1.0 - abs(x * 4.0 - 1.0));
}

void main() {
    vec2 tc = v_texcoord;
    vec2 middle = vec2(sin(time) * 0.5 + 0.5, cos(time) * 0.5 + 0.5);
    vec2 diff = tc - middle;
    float dist = length(diff);

    float alpha = 1.0 / dist * sin(-time) * 0.01;
    mat2 rotation = mat2(cos(alpha), -sin(alpha), sin(alpha), cos(alpha));
    // Invert distance and smooth it: closer to mouse means stronger warp
    float strength = 0.005 / (dist * dist + 0.01);

    // Warp direction - push pixels away from the mouse position
    vec2 warp = normalize(diff) * strength;

    // Apply warp to texture coordinates
    vec2 warped_tc = tc + warp;

    // Clamp so we don't sample outside texture
    warped_tc = clamp(warped_tc, 0.0, 1.0);

    vec4 color = texture2D(tex, rotation * (tc - middle) + middle);

    // rainbow
    vec4 new_color = vec4(
        color.r * f(fract(time)) + color.g * f(fract(time + 0.333)) + color.b * f(fract(time + 0.667)),
        color.r * f(fract(time + 0.333)) + color.g * f(fract(time + 0.667)) + color.b * f(fract(time)),
        color.r * f(fract(time + 0.667)) + color.g * f(fract(time)) + color.b * f(fract(time + 0.333)),
        1.0
    );

    vec3 clamped = clamp(color.rgb, 0.5, 1.0);
    new_color.rgb += vec3(color.b * f(warped_tc.x), color.g * f(warped_tc.y), color.r * f(warped_tc.x + warped_tc.y));

    gl_FragColor = new_color;
}
