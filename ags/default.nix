{
    username,
    inputs,
    pkgs,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        imports = [
            inputs.ags.homeManagerModules.default
        ];

        gtk = {
            enable = true;
            theme.name = "Orchis-Dark";
        };


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

        xdg.configFile."./ags/config.js".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/ags/config.js";
    };
}
