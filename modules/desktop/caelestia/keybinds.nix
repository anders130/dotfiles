{
    hm.wayland.windowManager.hyprland.settings = {
        bind = [
            "SUPER, SPACE, global, caelestia:launcher"
            "SUPER, BACKSPACE, global, caelestia:lock" # lock screen
            "SUPER+SHIFT, S, global, caelestia:screenshot"
            "CTRL+SUPER, R, exec, caelestia record"
            "ALT+SUPER, R, exec, caelestia record -r"
        ];
        bindr = [
            "CTRL+SUPER+SHIFT, R, exec, systemctl --user restart caelestia.service"
        ];
        bindl = [
            ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
            ", XF86MonBrightnessDown, global, caelestia:brightnessDown"
            # restore lock
            "CTRL+SUPER, BACKSPACE, exec, caelestia shell -d"
            "CTRL+SUPER, BACKSPACE, global, caelestia:lock"
        ];
        bindle = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
    };
}
