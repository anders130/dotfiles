{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: lib.mkModule config ./. {
    services.upower.enable = true;

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
            "ags/config.js" = lib.mkSymlink config {
                source = ./config.js;
            };
            "ags/style.css" = lib.mkSymlink config {
                source = ./style.css;
            };
            "ags/components" = lib.mkSymlink config {
                source = ./components;
                recursive = true;
            };
            "ags/utils" = lib.mkSymlink config {
                source = ./utils;
                recursive = true;
            };
        };
    };
}
