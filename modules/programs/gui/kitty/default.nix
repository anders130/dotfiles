{lib, ...}: {
    hm.programs.kitty = {
        enable = true;
        keybindings."ctrl+backspace" = "send_text all \\x17";
        settings = {
            confirm_os_window_close = 0; # disable confirmation window

            cursor_trail = 3;
            cursor_trail_decay = "0.1 0.4";

            window_padding_width = 5;
            placement_strategy = "top-left";
            hide_window_decorations = "yes";

            # disable bell
            bell_path = "none";
            enable_audio_bell = "no";

            disable_ligatures = "always";
        };
        extraConfig = ''
            include $NH_FLAKE/${lib.mkRelativePath ./kitty.conf}
        '';
    };
}
