{
    lib,
    pkgs,
    ...
}: let
    package = pkgs.kitty;
    configPath = lib.mkRelativePath ./kitty.conf;
in {
    environment.systemPackages = [package];

    hm.programs.kitty = {
        inherit package;
        enable = true;
        settings = {
            confirm_os_window_close = 0; # disable confirmation window

            window_padding_width = 5;
            placement_strategy = "top-left";
            hide_window_decorations = "yes";

            # disable bell
            bell_path = "none";
            enable_audio_bell = "no";

            disable_ligatures = "always";
        };
        extraConfig = ''
            include $FLAKE/${configPath}
        '';
    };
}
