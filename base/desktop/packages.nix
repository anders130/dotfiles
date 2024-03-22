{
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        firefox
        bitwarden
    ];

    stable-packages = with pkgs; [
        alacritty
        kitty
    ];
in {
    environment.systemPackages = 
        stable-packages
        ++ unstable-packages;
}
