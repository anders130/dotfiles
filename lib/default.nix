{
    inputs,
    lib,
}: {
    mkSymlink = import ./mkSymlink.nix {inherit inputs lib;};
    hexToRgb = import ./hexToRgb.nix {inherit inputs lib;};
}
