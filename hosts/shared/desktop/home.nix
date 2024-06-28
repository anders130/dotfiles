{
    config,
    pkgs,
    ...
}: {
    gtk = {
        enable = true;
        theme = {
            name = "Catppuccin-Macchiato-Compact-Blue-Dark";
            package = pkgs.catppuccin-gtk.override {
                accents = ["blue"];
                size = "compact";
                variant = "macchiato";
            };
        };
    };

    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
        };
    };

    home.pointerCursor = {
        name = "Catppuccin-Macchiato-Dark-Cursors";
        package = pkgs.catppuccin-cursors.macchiatoDark;
        size = 16;
        gtk.enable = true;
    };

    xdg.configFile = {
        "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";

        "vesktop/themes/catppuccin-macchiato.theme.css".text = /*css*/''
            /**
             * @name Catppuccin Macchiato
             * @author winston#0001
             * @authorId 505490445468696576
             * @version 0.2.0
             * @description 🎮 Soothing pastel theme for Discord
             * @website https://github.com/catppuccin/discord
             * @invite r6Mdz5dpFc
             * **/

            @import url("https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css");
        '';
    };

    xdg.userDirs.enable = true;
}
