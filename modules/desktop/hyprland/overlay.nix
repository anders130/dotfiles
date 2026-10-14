{
    dots.desktop.provides.hyprland.nixos = {inputs', ...}: {
        nixpkgs.overlays = [
            (final: _: {
                # TODO: remove this once glaze is updated in hyprland's CMakeLists
                hyprland = inputs'.hyprland.packages.hyprland.override {
                    glaze-hyprland = (final.glaze.override {
                        enableSSL = false;
                        enableInterop = false;
                    })
                        .overrideAttrs (_: {
                        version = "7.9.0";
                        src = final.fetchFromGitHub {
                            owner = "stephenberry";
                            repo = "glaze";
                            tag = "v7.9.0";
                            hash = "sha256-vNhxBdGaM70YABfwczvJcAFIYdEGIUGE8Sp2sgkTcaQ=";
                        };
                    });
                };
                inherit (inputs'.hyprland.packages) xdg-desktop-portal-hyprland;
            })
        ];
    };
}
