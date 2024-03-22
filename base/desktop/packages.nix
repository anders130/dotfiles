{
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        firefox
        bitwarden
    ];

    stable-packages = with pkgs; [
    ];
in {
    environment.systemPackages = 
        stable-packages
        ++ unstable-packages;
}
