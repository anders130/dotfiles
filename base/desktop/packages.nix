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
        gnome.nautilus
    ];
in {
    environment.systemPackages = 
        stable-packages
        ++ unstable-packages;
}
