{pkgs, ...}: let
    catpuccin-theme = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/CalfMoon/signal-desktop/658cb182d49dc6ba3085c7b63db0987e875a29bf/themes/catppuccin-macchiato.css";
        sha256 = "sha256-PAuHJD28uuVVYQRg7G48IFeIUZuMzXFfptwoC3Ef4dY=";
    };
in {
    environment.systemPackages = [
        (
            pkgs.signal-desktop.overrideAttrs (final: prev: {
                buildInputs = prev.buildInputs ++ [pkgs.asar];
                postInstall = ''
                    asar extract $out/lib/signal-desktop/resources/app.asar temp/
                    cp ${catpuccin-theme} temp/stylesheets/catppuccin-macchiato.css
                    sed -i "1i @import \"catppuccin-macchiato.css\";" "temp/stylesheets/manifest.css"
                    asar pack --unpack '*.node' temp/ $out/lib/signal-desktop/resources/app.asar
                '';
            })
        )
    ];
}
