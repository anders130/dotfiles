{nixosConfig}: let
    defaultPrograms = nixosConfig.modules.desktop.defaultPrograms; # TODO: make this work
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
        "SUPER, Space, exec, pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf" # app launcher
        "SUPER, BACKSPACE, exec, hyprlock" # lock screen
        "SUPER SHIFT, S, exec, grimblast --freeze copy area" # select area to copy
        "SUPER, T, exec, switch-shaders" # switch screen-shader
        "SUPER, N, exec, swaync-client -t -sw"
        "SUPER ALT, W, exec, wallpaper-selector ~/Pictures/Wallpapers ~/.config/rofi/wallpaper-selector.rasi" # wallpaper selector
        # mute/unmute
        " , code:121, exec, swayosd-client --output-volume mute-toggle"
        # workspaces
    ]
    ++ (builtins.concatLists (builtins.genList (
        x: let
            ws = let c = (x + 1) / 10; in toString (x + 1 - (c * 10));
        in [
            "SUPER, ${ws}, split-workspace, ${toString (x + 1)}"
            "SUPER Shift, ${ws}, split-movetoworkspace, ${toString (x + 1)}"
        ]
    )
    10))
    ++ [
        # special workspaces
        "SUPER, D, togglespecialworkspace, magic"
        "SUPER SHIFT, D, movetoworkspace, special:magic"
        "SUPER, G, togglespecialworkspace, other"
        "SUPER SHIFT, G, movetoworkspace, special:other"
    ]
