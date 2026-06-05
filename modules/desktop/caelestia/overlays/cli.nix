{
    dots.desktop.provides.caelestia.nixos = {inputs', ...}: {
        nixpkgs.overlays = [
            (final: _: {
                caelestia-cli = inputs'.caelestia-cli.packages.default.overrideAttrs (oldAttrs: {
                    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [final.pulseaudio];
                });
            })
        ];
    };
}
