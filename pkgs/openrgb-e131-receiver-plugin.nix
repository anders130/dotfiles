{
    lib,
    stdenv,
    fetchFromGitea,
    glib,
    openal,
    pkg-config,
    kdePackages,
}:
stdenv.mkDerivation (finalAttrs: rec {
    pname = "openrgb-plugin-e131-receiver";
    version = "candidate_1.0rc2";

    src = fetchFromGitea {
        domain = "codeberg.org";
        owner = "OpenRGB";
        repo = "OpenRGBE131ReceiverPlugin";
        rev = "release_${version}";
        sha256 = "sha256-dQpsISZ52t4OH/nPdkv1UvNXTJL/m7KfvVRhgrZ7Ev4=";
        fetchSubmodules = true;
    };

    nativeBuildInputs = [
        pkg-config
        kdePackages.wrapQtAppsHook
        kdePackages.qmake
    ];

    buildInputs = [
        kdePackages.qtbase
        kdePackages.qt5compat
        glib
        openal
    ];

    meta = with lib; {
        homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
        description = "Effects plugin for OpenRGB";
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [fgaz];
        platforms = platforms.linux;
    };
})
