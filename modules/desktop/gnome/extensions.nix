{pkgs, ...}: let
    extensions = with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        focus-changer
        fullscreen-avoider
        system-monitor
        forge
    ];
in {
    config = cfg: {
        environment.systemPackages = extensions;

        hm.dconf.settings = {
            "org/gnome/shell" = {
                enabled-extensions = map (e: e.extensionUuid) extensions;
                disable-user-extensions = false;
            };

            "org/gnome/shell/extensions/blur-my-shell" = {
                brightness = 0.9;
            };
            "org/gnome/shell/extensions/blur-my-shell/applications" = {
                blue = true;
                dynamic-opacity = false;
                enable-all = true;
                opacity = 190;
                blacklist = ["firefox" "zen-alpha"];
            };
            "org/gnome/shell/extensions/blur-my-shell/overview".style-components = 2; # dark background in overview

            "org/gnome/shell/extensions/forge" = {
                move-pointer-focus-enabled = true;
            };
            "org/gnome/shell/extensions/forge/keybindings" = {
                window-swap-last-active = [""];
                window-toggle-floating = ["<Super>v"];
            };
        };
    };
}
