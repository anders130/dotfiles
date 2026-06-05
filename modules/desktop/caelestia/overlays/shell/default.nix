{lib, ...}: {
    dots.desktop.provides.caelestia = {host, ...}: {
        nixos = {inputs', ...}: {
            nixpkgs.overlays = [
                (final: prev: {
                    caelestia-shell = (inputs'.caelestia-shell.packages.default.override {
                        extraRuntimeDeps = with prev; [
                            pulseaudio
                            ddcutil
                        ];
                    }).overrideAttrs (oldAttrs: {
                        patches =
                            [./patches/fix-lock-screen.patch]
                            ++ lib.optionals (host.caelestia.showAudio or false) [./patches/audio-switcher.patch];
                        postInstall =
                            (oldAttrs.postInstall or "")
                            + ''
                                printf '\nauth    optional    /run/current-system/sw/lib/security/pam_gnome_keyring.so\n' \
                                    >> $out/share/caelestia-shell/assets/pam.d/passwd
                            '';
                    });
                })
            ];
        };
    };
}
