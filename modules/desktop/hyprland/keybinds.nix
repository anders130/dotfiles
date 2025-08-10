{
    hm.wayland.windowManager.hyprland.settings = {
        bind = [
            "SUPER, Space, exec, pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf" # app launcher
            "SUPER, BACKSPACE, exec, hyprlock" # lock screen
            "SUPER SHIFT, S, exec, grimblast --freeze copy area" # select area to copy
            "SUPER, N, exec, swaync-client -t -sw"
            "SUPER ALT, W, exec, wallpaper-selector ~/Pictures/Wallpapers ~/.config/rofi/wallpaper-selector.rasi" # wallpaper selector
            "SUPER ALT, S, exec, shader-selector" # shader selector
        ];
        binde = [
            ## adjust volume
            " , code:122, exec, swayosd-client --output-volume -5"
            " , code:123, exec, swayosd-client --output-volume +5"
            ## adjust brightness (only works on laptops)
            " , code:232, exec, swayosd-client --brightness -5"
            " , code:233, exec, swayosd-client --brightness +5"
        ];
    };
}
