{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options = {
        modules.rofi.enable = lib.mkEnableOption "rofi";
    };

    config = lib.mkIf config.modules.rofi.enable {
        environment.systemPackages = with pkgs; [
            rofimoji
        ];

        home-manager.users.${username} = {config, ...}: {
            programs.rofi = {
                enable = true;
                package = pkgs.rofi-wayland;
                theme = "theme";
                terminal = "${pkgs.unstable.alacritty}/bin/alacritty";
            };

            xdg.configFile."rofi/theme.rasi" = lib.mkSymlink {
                config = config;
                source = "modules/rofi/theme.rasi";
            };

            xdg.configFile."rofimoji.rc".text = ''
                action = copy
                skin-tone = neutral
                max-recent = 0
            '';
        };
    };
}
