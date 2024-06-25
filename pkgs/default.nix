{
    system,
    pkgs,
}: let
    callPackage = pkgs.callPackage;
in {
    hyprsome = callPackage ./hyprsome.nix {};
    win32yank = callPackage ./win32yank.nix {};
}
