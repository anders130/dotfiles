{inputs, ...}: {
    flake-file.inputs.catppuccin-qutebrowser = {
        url = "github:catppuccin/qutebrowser";
        flake = false;
    };
    den.aspects.qutebrowser.homeManager = {
        programs.qutebrowser = {
            enable = true;
            enableDefaultBindings = true;
            extraConfig = ''
                import catppuccin
                catppuccin.setup(c, 'macchiato', True)

                # hide stuff
                config.bind('xs', 'config-cycle statusbar.show always never')
                config.bind('xt', 'config-cycle tabs.show always never')
                config.bind('xx', 'config-cycle tabs.show always never;; config-cycle statusbar.show always never')

                # swap dark/light mode
                config.bind('xd', 'config-cycle colors.webpage.darkmode.enabled true false')
            '';
            settings = {
                tabs.position = "left";
                colors.webpage.darkmode.enabled = true;
            };
        };
        xdg.configFile."qutebrowser/catppuccin".source = inputs.catppuccin-qutebrowser;
    };
}
