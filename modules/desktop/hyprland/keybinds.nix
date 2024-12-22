{config, ...}: {
    hm.wayland.windowManager.hyprland.settings = {
        input = {
            kb_layout = config.modules.utils.keyboard.layout;
            kb_variant = config.modules.utils.keyboard.variant;
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            numlock_by_default = true;
            repeat_delay = 250;
            repeat_rate = 25;

            follow_mouse = 1;
            mouse_refocus = 0;

            touchpad.natural_scroll = false;
            sensitivity = 0;
        };

        bind = let
            e = "ags -b hypr";
            defaultPrograms = config.modules.desktop.defaultPrograms;
        in [
            # ags stuff
            "SUPER CTRL SHIFT, R, exec, ${e} quit; ${e}"
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
            "SUPER, Space, exec, pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf" # app launcher
            "SUPER, Period, exec, rofi -modi emoji:rofimoji -show emoji" # emoji picker
            "SUPER, BACKSPACE, exec, hyprlock" # lock screen
            "SUPER SHIFT, S, exec, grimblast --freeze copy area" # select area to copy
            "SUPER, T, exec, switch-shaders" # switch screen-shader
            "SUPER, N, exec, swaync-client -t -sw"
            # workspaces
        ] ++ (builtins.concatLists (builtins.genList (
            x: let
                ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
            in [
                "SUPER, ${ws}, split-workspace, ${toString (x + 1)}"
                "SUPER Shift, ${ws}, split-movetoworkspace, ${toString (x + 1)}"
            ]
        )10)) ++ [
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
