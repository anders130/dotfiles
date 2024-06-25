{
    inputs,
    lib,
}: {
    mkSymlink = import ./mkSymlink.nix {inherit inputs lib;};
}
