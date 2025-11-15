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
    openrgb-plugin-effects = prev.openrgb-plugin-effects.overrideAttrs (old: {
        src = prev.fetchFromGitea {
            domain = "codeberg.org";
            owner = "OpenRGB";
            repo = "OpenRGBEffectsPlugin";
            rev = "release_candidate_1.0rc2";
            sha256 = "sha256-0W0hO3PSMpPLc0a7g/Nn7GWMcwBXhOxh1Y2flpdcnfE=";
            fetchSubmodules = true;
        };
        version = "1.0rc2";
        patches = [];

        nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ [
                prev.qt6.qtbase
                prev.qt6.qttools
            ];

        preConfigure = ''
            export PATH=${prev.qt6.qtbase}/bin:$PATH
        '';

        postPatch = ''
            cp -r ${final.openrgb.src} OpenRGB

            # Fix SPDWrapper includes
            for f in OpenRGB/**/*.cpp OpenRGB/**/*.h; do
              substituteInPlace "$f" \
                --replace-quiet '#include "SPDWrapper.h"' '#include "SPDAccessor/SPDWrapper.h"'
            done

            pipewireInc=${prev.pipewire.dev}/include
            pipewirePipeInc=${prev.pipewire.dev}/include/pipewire-0.3
            pipewireSpaInc=${prev.pipewire.dev}/include/spa-0.2

            echo "INCLUDEPATH += ''${pipewireInc} ''${pipewirePipeInc} ''${pipewireSpaInc}" >> OpenRGBEffectsPlugin.pro
            echo "LIBS += -L${prev.pipewire}/lib -lpipewire-0.3" >> OpenRGBEffectsPlugin.pro
        '';

        postConfigure = ''
            # Replace lrelease path in Makefile with the correct binary from qttools
            substituteInPlace Makefile \
              --replace '${prev.qt6.qtbase}/bin/lrelease' '${prev.qt6.qttools}/bin/lrelease'
        '';
    });
}
