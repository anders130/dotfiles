{pkgs, ...}: let
    unstable-packages = with pkgs.unstable; [
        bitwarden
        obsidian
        signal-desktop # oss messenger
        whatsapp-for-linux # bad messenger
        insomnia # postman-alternative
        grim # whole screen screenshot
        grimblast # region screenshot
        libreoffice
        godot_4
        protonmail-desktop

        pavucontrol # sound control
    ];

    stable-packages = with pkgs; [
        gnome.cheese # camera
        gnome.totem # video player
        loupe # gnome image viewer
        gnome.gnome-calculator
        gnome.gnome-music # music player
        bottles # windows programs

        fluent-gtk-theme
        orchis-theme

        # icon themes
        gnome.adwaita-icon-theme # just having this installed fixes issues with some apps

        gnome.dconf-editor # needed for home-manager gtk theming
        gojq

        youtube-music

        # work
        teams-for-linux
    ];
in {
    environment.systemPackages =
        stable-packages
        ++ unstable-packages;

    services.xserver.excludePackages = [
        pkgs.xterm
    ];

    programs.noisetorch.enable = true;
}
