{
    perSystem = {pkgs, ...}: {
        packages.caveman = pkgs.stdenvNoCC.mkDerivation rec {
            pname = "caveman";
            version = "1.8.2";

            src = pkgs.fetchFromGitHub {
                owner = "JuliusBrussee";
                repo = "caveman";
                tag = "v${version}";
                hash = "sha256-Jlfas2MPoQx3pOw+yKCta8kYlOEY27SP5NXJtSL+GGI=";
            };

            installPhase = ''
                runHook preInstall
                mkdir -p "$out"
                cp -r . "$out/"
                runHook postInstall
            '';

            meta = let
                inherit (pkgs.lib) licenses platforms;
            in {
                description = "Ultra-compressed communication mode for coding agents";
                homepage = "https://github.com/JuliusBrussee/caveman";
                license = licenses.mit;
                platforms = platforms.all;
            };
        };
    };
}
