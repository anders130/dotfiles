{
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        firefox
        bitwarden
    ];

    stable-packages = with pkgs; [
        alacritty # terminal
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
}
