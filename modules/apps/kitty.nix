{
    inputs,
    config,
    ...
}: let
    inherit (config.flake.lib) style;
in {
    flake-file.inputs.tinted-terminal = {
        url = "github:tinted-theming/tinted-terminal";
        flake = false;
    };

    flake.wrappers.kitty = {
        pkgs,
        lib,
        ...
    }: let
        theme = style.colors pkgs lib {
            template = builtins.readFile "${inputs.tinted-terminal}/templates/kitty-base16.mustache";
            extension = ".conf";
        };
    in {
        imports = [inputs.wrapper-modules.wrapperModules.kitty];

        font = {
            inherit (style.monospace) name;
            size = style.terminalSize;
        };

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

            background_opacity = "0.9";
        };

        extraConfig = ''
            include ${theme}
        '';
    };

    den.aspects.kitty.homeManager = {self', ...}: {
        home.packages = [self'.packages.kitty];
    };
}
