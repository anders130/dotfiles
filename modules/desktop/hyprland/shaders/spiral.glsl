precision mediump float;
varying vec2 v_texcoord;

uniform float time;
uniform sampler2D tex;

void main() {
    vec2 tc = v_texcoord;
    vec2 middle = vec2(0.5, 0.5);
    vec2 diff = tc - middle;
    float dist = length(diff);

    float alpha = 1.0 / dist;
    mat2 rotation = mat2(cos(alpha), -sin(alpha), sin(alpha), cos(alpha));
    // Invert distance and smooth it: closer to mouse means stronger warp
    float strength = 0.005 / (dist * dist + 0.01);

    // Warp direction - push pixels away from the mouse position
    vec2 warp = normalize(diff) * strength;

    // Apply warp to texture coordinates
    vec2 warped_tc = tc + warp;

    // Clamp so we don't sample outside texture
    warped_tc = clamp(warped_tc, 0.0, 1.0);

    vec4 color = texture2D(tex, rotation * (warped_tc - middle) + middle);

    gl_FragColor = color;
}
