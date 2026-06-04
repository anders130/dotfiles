{inputs, ...}: {
    flake.modules.nixos.caelestia = {
        nixpkgs.overlays = [
            (final: prev: {
                caelestia-cli = inputs.caelestia-cli.packages.${prev.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
                    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [final.pulseaudio];
                });
            })
        ];
    };
}
