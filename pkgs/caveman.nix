{
    lib,
    stdenvNoCC,
    fetchFromGitHub,
}: let
    inherit (lib) licenses platforms;
in
stdenvNoCC.mkDerivation rec {
    pname = "caveman";
    version = "1.6.0";

    src = fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        tag = "v${version}";
        hash = "sha256-m7HhCW4fXU5pIYRWVP6cvSYUkDHt8R90D9UI3tT7euk=";
    };

    installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r . "$out/"
        runHook postInstall
    '';

    meta = {
        description = "Ultra-compressed communication mode for coding agents";
        homepage = "https://github.com/JuliusBrussee/caveman";
        license = licenses.mit;
        platforms = platforms.all;
    };
}
