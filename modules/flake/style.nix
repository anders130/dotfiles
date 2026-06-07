{
    flake.lib.style = {
        scheme = "catppuccin-macchiato"; # base16-schemes file basename
        polarity = "dark";
        monospace = {
            package = pkgs: pkgs.nerd-fonts.caskaydia-cove;
            name = "CaskaydiaCove NF";
        };
        terminalSize = 14;
    };
}
