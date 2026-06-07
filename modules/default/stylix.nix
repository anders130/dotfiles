{
    inputs,
    config,
    ...
}: let
    inherit (config.flake.lib) style;
in {
    flake-file.inputs.stylix.url = "github:danth/stylix";
    den.default = {
        nixos = {pkgs, ...}: {
            imports = [inputs.stylix.nixosModules.stylix];
            stylix = {
                inherit (style) polarity;
                enable = true;
                enableReleaseChecks = false;
                base16Scheme = "${pkgs.base16-schemes}/share/themes/${style.scheme}.yaml";
                targets = {
                    console.enable = false;
                    kmscon.enable = false;
                };
            };
        };
        homeManager = {lib, ...}: {
            stylix = {
                enableReleaseChecks = false;
                targets.gtk.enable = lib.mkDefault false;
            };
        };
    };
}
