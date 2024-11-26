{
    pkgs,
    username,
    ...
}: let
    package = pkgs.kitty;
in {
    environment.systemPackages = [package];

    home-manager.users.${username} = {
        programs.kitty = {
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
            extraConfig = /*bash*/''
                # for better faster configuration iteration
                include $FLAKE/modules/applications/kitty/kitty.conf
            '';
        };
    };
}
