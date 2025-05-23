{pkgs, ...}: let
    catpuccin-theme = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/CalfMoon/signal-desktop/658cb182d49dc6ba3085c7b63db0987e875a29bf/themes/catppuccin-macchiato.css";
        sha256 = "sha256-PAuHJD28uuVVYQRg7G48IFeIUZuMzXFfptwoC3Ef4dY=";
    };
in {
    environment.systemPackages = [
        (
            pkgs.signal-desktop.overrideAttrs (final: prev: {
                nativeBuildInputs = (prev.nativeBuildInputs or []) ++ [pkgs.asar];
                postInstall = ''
                    tmpdir=$(mktemp -d)

                    cp $out/share/signal-desktop/app.asar $tmpdir/app.asar
                    cp -r $out/share/signal-desktop/app.asar.unpacked $tmpdir/app.asar.unpacked
                    chmod -R +w $tmpdir/app.asar.unpacked
                    cd $tmpdir

                    ${pkgs.asar}/bin/asar extract app.asar app
                    cp ${catpuccin-theme} app/stylesheets/catppuccin-macchiato.css
                    sed -i '1i @import "catppuccin-macchiato.css";' app/stylesheets/manifest.css

                    ${pkgs.asar}/bin/asar pack --unpack '*.node' app app.asar

                    cp app.asar $out/share/signal-desktop/app.asar
                '';
            })
        )
    ];
}
