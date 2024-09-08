{
    inputs,
    lib,
    system
}: let
    mkImport = path: import path {inherit inputs lib system;};
in {
    getPkgs = mkImport ./getPkgs.nix;
    hexToRgb = mkImport ./hexToRgb.nix;
    mkSymlink = mkImport ./mkSymlink.nix;
}
