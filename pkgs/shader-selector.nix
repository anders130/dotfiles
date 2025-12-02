{
    rofi,
    hyprland,
    pkgs,
}:
pkgs.writeShellApplication {
    name = "shader-selector";
    runtimeInputs = [rofi hyprland];
    text = ''
        shader_dir="$HOME/.config/hypr/shaders/"

        selected_shader=$(find "$shader_dir" -maxdepth 1 -type f -name "*.glsl" -printf "%f\n" | rofi -dmenu -p "Select Shader")

        if [ -z "$selected_shader" ]; then
            exit 0
        fi

        shader_path="$shader_dir/$selected_shader"

        if grep -q "uniform float time;" "$shader_path"; then
            hyprctl keyword debug:damage_tracking false
        else
            hyprctl keyword debug:damage_tracking true
        fi

        hyprctl keyword decoration:screen_shader "$shader_path"
    '';
}
