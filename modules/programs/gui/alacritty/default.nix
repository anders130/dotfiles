{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.programs.gui.alacritty = {
        enable = lib.mkEnableOption "alacritty";
    };

    config = lib.mkIf config.modules.programs.gui.alacritty.enable {
        environment.systemPackages = [
            pkgs.unstable.alacritty
        ];

        home-manager.users.${username} = {config, ...}: {
            xdg.configFile.alacritty = lib.mkSymlink config {
                source = "modules/programs/gui/alacritty";
                recursive = true;
            };
        };
    };
}
