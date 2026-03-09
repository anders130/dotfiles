inputs: final: prev: let
    inherit (builtins) attrNames readDir;
in {
    caelestia-shell = (inputs.caelestia-shell.packages.${prev.stdenv.hostPlatform.system}.default.override {
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
        postInstall =
            (oldAttrs.postInstall or "")
            + ''
                printf '\nauth    optional    /run/current-system/sw/lib/security/pam_gnome_keyring.so\n' \
                    >> $out/share/caelestia-shell/assets/pam.d/passwd
            '';
    });
}
