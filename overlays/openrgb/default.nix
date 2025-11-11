_: final: prev: {
    openrgb = prev.openrgb.overrideAttrs (old: {
        src = prev.fetchFromGitea {
            domain = "codeberg.org";
            owner = "OpenRGB";
            repo = "OpenRGB";
            rev = "release_candidate_1.0rc2";
            sha256 = "sha256-vdIA9i1ewcrfX5U7FkcRR+ISdH5uRi9fz9YU5IkPKJQ=";
        };
        # See patch discussion https://github.com/NixOS/nixpkgs/issues/446002
        patches = [
            ./remove_systemd_service.patch
        ];
        postPatch = ''
            patchShebangs scripts/build-udev-rules.sh
            substituteInPlace scripts/build-udev-rules.sh \
            --replace-fail /usr/bin/env "${prev.coreutils}/bin/env"
        '';
        version = "1.0rc2";
        buildInputs = map (
            dep:
                if dep.pname or "" == "mbedtls"
                then final.mbedtls
                else dep
        )
        old.buildInputs;
    });
}
