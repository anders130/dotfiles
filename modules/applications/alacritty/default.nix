{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.applications.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };

    config = lib.mkIf config.modules.applications.alacritty.enable {
        environment.systemPackages = [
            pkgs.unstable.alacritty
        ];

        home-manager.users.${username} = {config, ...}: {
            xdg.configFile.alacritty = lib.mkSymlink config ./.;
        };
    };
}
