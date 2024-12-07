{
    inputs,
    lib,
    pkgs,
    ...
}: {
    services.upower.enable = true;

    environment.systemPackages = [
        pkgs.pulseaudio
    ];

    hm = {
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
            "ags/config.js" = lib.mkSymlink ./config.js;
            "ags/style.css" = lib.mkSymlink ./style.css;
            "ags/components" = lib.mkSymlink ./components;
            "ags/utils" = lib.mkSymlink ./utils;
        };
    };
}
