{
    username,
    inputs,
    pkgs,
    lib,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
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

        xdg.configFile."ags/config.js" = lib.home-symlink { config = config; source = "ags/config.js"; };
        xdg.configFile."ags/style.css" = lib.home-symlink { config = config; source = "ags/style.css"; };
        xdg.configFile."ags/components" = lib.home-symlink { config = config; source = "ags/components"; recursive = true; };
        xdg.configFile."ags/utils" = lib.home-symlink { config = config; source = "ags/utils"; recursive = true; };
    };
}
