{
    lib,
    stdenv,
    fetchFromGitHub,
    meson,
    ninja,
    pkgconf,
    inih,
    systemd,
    scdoc,
    xdg-desktop-portal,
}:
stdenv.mkDerivation {
    pname = "xdg-desktop-portal-termfilechooser";
    version = "git";

    src = fetchFromGitHub {
        owner = "hunkyburrito";
        repo = "xdg-desktop-portal-termfilechooser";
        rev = "c35af27";
        sha256 = "sha256-9bxhKkk5YFBhR2ylcDzlvt4ltYuF174w00EJK5r3aY0=";
    };

    nativeBuildInputs = [
        meson
        ninja
        scdoc
        pkgconf
    ];

    buildInputs = [
        xdg-desktop-portal
        inih
        systemd.dev
    ];

    mesonFlags = [
        (lib.mesonEnable "systemd" true)
        (lib.mesonEnable "man-pages" true)
        (lib.mesonOption "sd-bus-provider" "libsystemd")
    ];

    mesonBuildType = "release";

    meta = with lib; {
        description = "xdg-desktop-portal backend for terminal file choosers";
        homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
        license = licenses.mit;
        platforms = platforms.linux;
    };
}
