{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.applications.rofi;
in {
    options.modules.applications.rofi = {
        enable = lib.mkEnableOption "rofi";
        terminal = lib.mkOption {
            type = lib.types.str;
            default = "alacritty";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            rofimoji
        ];

        home-manager.users.${username} = {config, ...}: {
            stylix.targets.rofi.enable = false;

            programs.rofi = {
                enable = true;
                package = pkgs.rofi-wayland;
                theme = "theme";
                terminal = cfg.terminal;
                extraConfig.display-drun = " Apps ";
            };

            xdg.configFile = {
                "rofi/theme.rasi" = lib.mkSymlink config {
                    source = ./theme.rasi;
                };

                "rofimoji.rc".text = ''
                    action = copy
                    skin-tone = neutral
                    max-recent = 0
                '';
            };
        };
    };
}
