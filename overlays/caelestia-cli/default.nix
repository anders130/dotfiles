inputs: final: prev: {
    caelestia-cli = inputs.caelestia-cli.packages.${prev.system}.default.overrideAttrs (oldAttrs: {
        patchPhase =
            oldAttrs.patchPhase
            + ''
                echo "Applying no-auto-scheme-wallpaper.patch"
                patch -p1 < ${./patches/no-auto-scheme-wallpaper.patch}
            '';
    });
}
