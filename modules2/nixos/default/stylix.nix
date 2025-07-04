{pkgs}: {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    cursor = {
        name = "catppuccin-macchiato-dark-cursors";
        package = pkgs.catppuccin-cursors.macchiatoDark;
        size = 24;
    };
    fonts = {
        monospace = {
            package = pkgs.nerd-fonts.caskaydia-cove;
            name = "CaskaydiaCove NF"; # important, because the mono version has tiny symbols
        };
        sizes.terminal = 14;
    };
    polarity = "dark";

    targets.console.enable = false; # deactivate tty styling
}
