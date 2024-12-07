{
    inputs,
    myLib,
    pkgs,
    username,
    ...
}: {
    services.upower.enable = true;

    environment.systemPackages = [
        pkgs.pulseaudio
    ];

    home-manager.users.${username} = {
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
                webkitgtk_6_0
                accountsservice
            ];
        };

        xdg.configFile = {
            "ags/config.js" = myLib.mkSymlink ./config.js;
            "ags/style.css" = myLib.mkSymlink ./style.css;
            "ags/components" = myLib.mkSymlink ./components;
            "ags/utils" = myLib.mkSymlink ./utils;
        };
    };
}
