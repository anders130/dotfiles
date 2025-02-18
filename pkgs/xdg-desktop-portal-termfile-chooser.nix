{
    lib,
    stdenv,
    fetchFromGitHub,
    meson,
    ninja,
    pkg-config,
    inih,
    systemd,
    cmake,
    scdoc,
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
        pkg-config
        scdoc
        cmake
    ];
    buildInputs = [
        inih
        systemd.dev
    ];

    mesonFlags = ["-Dsd-bus-provider=libsystemd"];

    meta = with lib; {
        description = "xdg-desktop-portal backend for terminal file choosers";
        homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
        license = licenses.mit;
        platforms = platforms.linux;
    };
}
