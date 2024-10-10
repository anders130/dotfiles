{
    inputs,
    lib,
    system,
    isThinClient,
}: let
    mkImport = path: import path {inherit inputs lib system isThinClient;};
in {
    importFromDir = mkImport ./importFromDir;
    getPkgs = mkImport ./getPkgs.nix;
    hexToRgb = mkImport ./hexToRgb.nix;
    mkSymlink = mkImport ./mkSymlink.nix;
}
