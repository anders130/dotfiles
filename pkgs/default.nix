{
    system,
    pkgs,
}: let
    callPackage = pkgs.callPackage;
in {
    easyroam = callPackage ./easyroam.nix {};
    hyprsome = callPackage ./hyprsome.nix {};
    win32yank = callPackage ./win32yank.nix {};
}
