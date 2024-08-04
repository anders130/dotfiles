{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.ags = {
        enable = lib.mkEnableOption "ags";
    };

    config = lib.mkIf config.modules.ags.enable {
        environment.systemPackages = [
            pkgs.pulseaudio
        ];

        home-manager.users.${username} = {config, ...}: {
            imports = [
                inputs.ags.homeManagerModules.default
            ];

            programs.ags = {
                enable = true;
                # null or path, leave as null if you don't want hm to manage the config
                configDir = null;
                # additional packages to add to gjs's runtime
                extraPackages = with pkgs; [
                    gtksourceview
                    webkitgtk
                    accountsservice
                ];
            };

            xdg.configFile = {
                "ags/config.js" = lib.mkSymlink {
                    config = config;
                    source = "modules/ags/config.js";
                };
                "ags/style.css" = lib.mkSymlink {
                    config = config;
                    source = "modules/ags/style.css";
                };
                "ags/components" = lib.mkSymlink {
                    config = config;
                    source = "modules/ags/components";
                    recursive = true;
                };
                "ags/utils" = lib.mkSymlink {
                    config = config;
                    source = "modules/ags/utils";
                    recursive = true;
                };
            };
        };
    };
}
