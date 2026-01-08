{
    hm.wayland.windowManager.hyprland.settings = {
        general = {
            gaps_in = 2.5;
            gaps_out = 5;
            border_size = 3;
        };
        decoration.rounding = 10;
        layerrule =
            [
                "rofi"
                "gtk4-layer-shell" # ags
                "swaync-control-center"
                "swaync-notification-window"
                "swayosd"
            ]
            |> map (ns: "match:namespace ^(${ns})$, blur true, ignorezero true");
    };
}
