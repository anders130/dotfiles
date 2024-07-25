{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.applications.rofi = {
        enable = lib.mkEnableOption "rofi";
    };

    config = lib.mkIf config.modules.applications.rofi.enable {
        environment.systemPackages = with pkgs; [
            rofimoji
        ];

        home-manager.users.${username} = {config, ...}: {
            stylix.targets.rofi.enable = false;

            programs.rofi = {
                enable = true;
                package = pkgs.rofi-wayland;
                theme = "theme";
                terminal = "${pkgs.unstable.alacritty}/bin/alacritty"; # TODO: make this configurable
            };

            xdg.configFile."rofi/theme.rasi" = lib.mkSymlink {
                config = config;
                source = "modules/applications/rofi/theme.rasi";
            };

            xdg.configFile."rofimoji.rc".text = ''
                action = copy
                skin-tone = neutral
                max-recent = 0
            '';
        };
    };
}
