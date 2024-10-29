{
    system,
    pkgs,
}: let
    callPackage = pkgs.callPackage;
in {
    keil-uvision = callPackage ./keil-uvision {};
    easyroam = callPackage ./easyroam.nix {};
    hyprsome = callPackage ./hyprsome.nix {};
    win32yank = callPackage ./win32yank.nix {};
}
