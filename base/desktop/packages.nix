{
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        alacritty # terminal
        bitwarden
        firefox
        obsidian
        vesktop

        swww
    ];

    stable-packages = with pkgs; [
        gnome.nautilus # file explorer

        fluent-gtk-theme
        orchis-theme

        # icon themes
        gnome.adwaita-icon-theme # just having this installed fixes issues with some apps

        gnome.dconf-editor # needed for home-manager gtk theming
    ];
in {
    environment.systemPackages = 
        stable-packages
        ++ unstable-packages;

    services.xserver.excludePackages = [
        pkgs.xterm
    ];
}
