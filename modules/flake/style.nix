{inputs, ...}: {
    flake.lib.style = rec {
        scheme = "catppuccin-macchiato"; # base16-schemes file basename
        polarity = "dark";
        flavour = "macchiato";
        accent = "blue";
        monospace = {
            package = pkgs: pkgs.nerd-fonts.caskaydia-cove;
            name = "CaskaydiaCove NF"; # the mono build has tiny symbols, so use the NF (non-mono) build
        };
        terminalSize = 14;

        colors = pkgs: lib:
            (inputs.stylix.inputs.base16.lib {inherit pkgs lib;}).mkSchemeAttrs
            "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
    };
}
