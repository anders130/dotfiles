inputs: final: prev: {
    caelestia-cli = inputs.caelestia-cli.packages.${prev.system}.default;
    caelestia-shell = inputs.caelestia-shell.packages.${prev.system}.default.overrideAttrs (old: {
        patches = old.patches or [] ++ [./patches/ctrl-np.patch];
    });
}
