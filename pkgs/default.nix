{
    system,
    pkgs
}: let
    callPackage = pkgs.callPackage;
in {
    hyprsome = callPackage ./hyprsome.nix {};
}
