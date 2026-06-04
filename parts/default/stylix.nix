{inputs, ...}: {
    flake-file.inputs.stylix.url = "github:danth/stylix";
    flake.modules.nixos.default = {pkgs, ...}: {
        imports = [inputs.stylix.nixosModules.stylix];
        stylix = {
            enable = true;
            enableReleaseChecks = false;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
            polarity = "dark";
            targets = {
                console.enable = false;
                kmscon.enable = false;
            };
        };
    };
    flake.modules.homeManager.default = {lib, ...}: {
        stylix = {
            enableReleaseChecks = false;
            targets.gtk.enable = lib.mkDefault false;
        };
    };
}
