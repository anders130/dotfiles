{
    den,
    inputs,
    config,
    ...
}: let
    inherit (config.flake.lib) style;
in {
    flake-file.inputs.catppuccin-qutebrowser = {
        url = "github:catppuccin/qutebrowser";
        flake = false;
    };
    den.aspects.qutebrowser = {
        includes = [den.aspects.browser];
        homeManager = {
            config,
            lib,
            ...
        }: let
            cfg = config.my.browser;
            # qutebrowser uses {} as the query placeholder instead of vimium's %s
            quteUrl = url: lib.replaceStrings ["%s"] ["{}"] url;
        in {
            programs.qutebrowser = {
                enable = true;
                enableDefaultBindings = true;
                searchEngines =
                    {DEFAULT = quteUrl cfg.searchEngines.${cfg.defaultSearchEngine}.url;}
                    // lib.mapAttrs (_: e: quteUrl e.url) cfg.searchEngines;
                extraConfig = ''
                    import catppuccin
                    catppuccin.setup(c, '${style.flavour}', True)

                    # hide stuff
                    config.bind('xs', 'config-cycle statusbar.show always never')
                    config.bind('xt', 'config-cycle tabs.show always never')
                    config.bind('xx', 'config-cycle tabs.show always never;; config-cycle statusbar.show always never')

                    # swap dark/light mode
                    config.bind('xd', 'config-cycle colors.webpage.darkmode.enabled true false')
                '';
                settings = {
                    tabs.position = "left";
                    # hidden by default; toggle with xt / xx
                    tabs.show = "never";
                    colors.webpage.darkmode.enabled = true;
                };
            };
            xdg.configFile."qutebrowser/catppuccin".source = inputs.catppuccin-qutebrowser;
            my.desktop.windowRules.qutebrowser = {
                match = "org.qutebrowser.qutebrowser";
                opacity = "blur";
            };
        };
    };
}
