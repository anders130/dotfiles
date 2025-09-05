{config, ...}: {
    hm.wayland.windowManager.hyprland.settings = {
        input = with config.modules.utils.keyboard; {
            kb_layout = layout;
            kb_variant = variant;
            kb_model = "";
            kb_options = options;
            kb_rules = "";

            numlock_by_default = true;
            repeat_delay = 250;
            repeat_rate = 25;

            follow_mouse = 1;
            mouse_refocus = 0;

            touchpad.natural_scroll = true;
            sensitivity = 0;
        };

        bind = let
            inherit (config.modules.desktop) defaultPrograms;
        in
            [
                # essential keybinds
                "SUPER, C, killactive"
                "SUPER, V, togglefloating"
                "SUPER, F, fullscreen"
                "SUPER, S, togglesplit"
                "SUPER, P, pin"
                # move focus with vim-like keybinds
                "SUPER, h, movefocus, l"
                "SUPER, j, movefocus, d"
                "SUPER, k, movefocus, u"
                "SUPER, l, movefocus, r"
                # move clients with vim-like keybinds
                "SUPER SHIFT, h, movewindow, l"
                "SUPER SHIFT, j, movewindow, d"
                "SUPER SHIFT, k, movewindow, u"
                "SUPER SHIFT, l, movewindow, r"
                # programs
                "SUPER, return, exec, ${defaultPrograms.terminal}"
                "SUPER, E, exec, ${defaultPrograms.fileManager}"
                "SUPER, B, exec, ${defaultPrograms.browser}"
                "SUPER, Q, exec, qutebrowser"
                "SUPER ALT, C, exec, hyprpicker -a" # color picker
                # mute/unmute
                " , code:121, exec, swayosd-client --output-volume mute-toggle"
                # workspaces
            ]
            ++ (
                builtins.genList (x: toString (x + 1)) 9
                |> map (i: [
                    "SUPER, ${i}, split-workspace, ${i}"
                    "SUPER Shift, ${i}, split-movetoworkspace, ${i}"
                ])
                |> builtins.concatLists
            )
            ++ [
                # special workspaces
                "SUPER, D, togglespecialworkspace, magic"
                "SUPER SHIFT, D, movetoworkspace, special:magic"
                "SUPER, G, togglespecialworkspace, other"
                "SUPER SHIFT, G, movetoworkspace, special:other"
            ];

        bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
        ];
    };
}

