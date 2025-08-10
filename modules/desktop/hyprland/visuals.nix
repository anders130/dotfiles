{
    hm.wayland.windowManager.hyprland.settings = {
        general = {
            gaps_in = 2.5;
            gaps_out = 5;
            border_size = 3;
        };
        decoration.rounding = 10;
        layerrule = [
            # rofi
            "blur,       ^(rofi)$"
            "ignorezero, ^(rofi)$"
            # ags
            "blur,       ^(gtk4-layer-shell)$"
            "ignorezero, ^(gtk4-layer-shell)$"
            # swaync
            "blur,       ^(swaync-control-center)$"
            "ignorezero, ^(swaync-control-center)$"
            "blur,       ^(swaync-notification-window)$"
            "ignorezero, ^(swaync-notification-window)$"
            # swayosd
            "blur,       ^(swayosd)$"
            "ignorezero, ^(swayosd)$"
        ];
    };
}
