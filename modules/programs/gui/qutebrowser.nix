{inputs, ...}: {
    hm.programs.qutebrowser = {
        enable = true;
        enableDefaultBindings = true;
        extraConfig = ''
            import catppuccin
            catppuccin.setup(c, 'macchiato', True)
        '';
    };
    hm.xdg.configFile."qutebrowser/catppuccin".source = inputs.catppuccin-qutebrowser;
}
