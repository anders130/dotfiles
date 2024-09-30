{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.gnome;

    extensions = with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        fullscreen-avoider
        system-monitor
    ];
in {
    config = lib.mkIf cfg.enable {
        environment.systemPackages = extensions;

        home-manager.users.${username}.dconf.settings = {
            "org/gnome/shell".enabled-extensions = builtins.map (extension: extension.extensionUuid) extensions;

            "org/gnome/shell/extensions/blur-my-shell" = {
                brightness = 0.9;
            };
            "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 2; # dark background in overview
        };
    };
}
