{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.kitty = {
        enable = lib.mkEnableOption "kitty";
    };

    config = lib.mkIf config.modules.kitty.enable {
        environment.systemPackages = [
            pkgs.kitty
        ];

        home-manager.users.${username} = {
            programs.kitty = {
                enable = true;
                settings = {
                    confirm_os_window_close = 0; # disable confirmation window

                    window_padding_width = 5;
                    placement_strategy = "top-left";

                    # disable bell
                    bell_path = "none";
                    enable_audio_bell = "no";
                };
            };
        };
    };
}
