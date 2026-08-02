{
    dots.desktop.provides.caelestia.homeManager = {
        config,
        lib,
        ...
    }: let
        inherit (lib) genAttrs;
        inherit (config.lib.hyprland) hl;
        global = name: hl.global "caelestia:${name}";
        caelestia = args: hl.exec_cmd "caelestia ${args}";
        # bindin (ignore mods, don't consume the click/scroll)
        launcherInterruptKeys = [
            "SUPER + mouse:272"
            "SUPER + mouse:273"
            "SUPER + mouse:274"
            "SUPER + mouse:275"
            "SUPER + mouse:276"
            "SUPER + mouse:277"
            "SUPER + mouse_up"
            "SUPER + mouse_down"
        ];
    in {
        my.hyprland.binds =
            genAttrs launcherInterruptKeys (_: {
                dispatch = global "launcherInterrupt";
                opts = {
                    ignore_mods = true;
                    non_consuming = true;
                };
            })
            // {
                "SUPER + SPACE" = global "launcher";
                "SUPER + BACKSPACE" = global "lock"; # lock screen
                "SUPER + SHIFT + S" = global "screenshot";
                "CTRL + SUPER + R" = caelestia "record";
                "ALT + SUPER + R" = caelestia "record -r";
                "SUPER + N" = caelestia "shell drawers toggle sidebar";

                # bindr (release-triggered)
                "CTRL + SUPER + SHIFT + R" = {
                    dispatch = hl.exec_cmd "systemctl --user restart caelestia.service";
                    opts.release = true;
                };

                # bindl (works while locked)
                "XF86MonBrightnessUp" = {
                    dispatch = global "brightnessUp";
                    opts.locked = true;
                };
                "XF86MonBrightnessDown" = {
                    dispatch = global "brightnessDown";
                    opts.locked = true;
                };
                # restore lock
                "CTRL + SUPER + BACKSPACE" = [
                    {
                        dispatch = caelestia "shell -d";
                        opts.locked = true;
                    }
                    {
                        dispatch = global "lock";
                        opts.locked = true;
                    }
                ];

                # bindle (locked + repeats while held)
                "XF86AudioMute" = {
                    dispatch = hl.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                    opts = {
                        locked = true;
                        repeating = true;
                    };
                };
                "XF86AudioRaiseVolume" = {
                    dispatch = hl.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
                    opts = {
                        locked = true;
                        repeating = true;
                    };
                };
                "XF86AudioLowerVolume" = {
                    dispatch = hl.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                    opts = {
                        locked = true;
                        repeating = true;
                    };
                };
            };
    };
}
