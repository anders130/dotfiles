{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };

    config = lib.mkIf config.modules.alacritty.enable {
        environment.systemPackages = [
            pkgs.unstable.alacritty
        ];

        home-manager.users.${username} = {config, ...}: {
            xdg.configFile.alacritty = lib.mkSymlink {
                config = config;
                source = "modules/alacritty";
                recursive = true;
            };
        };
    };
}
