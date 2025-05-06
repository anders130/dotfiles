{inputs, ...}: {
    hm.programs.qutebrowser = {
        enable = true;
        enableDefaultBindings = true;
        extraConfig = ''
            import catppuccin
            catppuccin.setup(c, 'macchiato', True)

            # hide stuff
            config.bind('xs', 'config-cycle statusbar.show always never')
            config.bind('xt', 'config-cycle tabs.show always never')
            config.bind('xx', 'config-cycle tabs.show always never;; config-cycle statusbar.show always never')
        '';
        settings = {
            tabs.position = "left";
        };
    };
    hm.xdg.configFile."qutebrowser/catppuccin".source = inputs.catppuccin-qutebrowser;
}
