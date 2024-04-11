{
    pkgs,
    config,
    ...
}: {
    gtk = {
        enable = true;
        theme = {
            name = "Catppuccin-Macchiato-Compact-Blue-Dark";
            package = pkgs.catppuccin-gtk.override {
                accents = [ "blue" ];
                size = "compact";
                variant = "macchiato";
            };
        };
    };

    xdg.configFile = {
        "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };

    #
    # programs.hyprlock.enable = true;
}
