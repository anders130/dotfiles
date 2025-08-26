inputs: final: prev: let
    inherit (builtins) attrNames readDir;
in {
    caelestia-shell = (inputs.caelestia-shell.packages.${prev.system}.default.override {
        extraRuntimeDeps = with prev; [
            pulseaudio
            ddcutil
        ];
    }).overrideAttrs (oldAttrs: {
        patches =
            ./patches
            |> readDir
            |> attrNames
            |> map (n: ./patches/${n});
    });
}
