{
    lib,
    pkgs,
    username,
    ...
}: {
    options = {
        terminal = lib.mkOption {
            type = lib.types.str;
            default = "alacritty";
        };
    };

    config = cfg: {
        environment.systemPackages = with pkgs; [
            rofimoji
        ];

        home-manager.users.${username} = {
            stylix.targets.rofi.enable = false;

            programs.rofi = {
                enable = true;
                package = pkgs.rofi-wayland;
                theme = "theme";
                terminal = cfg.terminal;
                extraConfig.display-drun = " Apps ";
            };

            xdg.configFile = {
                "rofi/theme.rasi" = lib.mkSymlink ./theme.rasi;

                "rofimoji.rc".text = ''
                    action = copy
                    skin-tone = neutral
                    max-recent = 0
                '';
            };
        };
    };
}
