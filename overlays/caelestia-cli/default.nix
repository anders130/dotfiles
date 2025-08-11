inputs: final: prev: {
    caelestia-cli = inputs.caelestia-cli.packages.${prev.system}.default.overrideAttrs (oldAttrs: {
        patchPhase = let
            inherit (builtins) attrNames readDir;
            patches =
                ./patches
                |> readDir
                |> attrNames
                |> map (n: ./patches/${n});
        in
            oldAttrs.patchPhase
            + ''
                echo "Applying no-auto-scheme-wallpaper.patch"
                ${builtins.concatStringsSep "\n" (map (p: "patch -p1 < ${p}") patches)}
            '';
    });
}
