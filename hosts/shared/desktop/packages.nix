{pkgs, ...}: let
    unstable-packages = with pkgs.unstable; [
        alacritty # terminal
        bitwarden
        obsidian
        google-chrome
        gnome.totem # video player
        signal-desktop # oss messenger
        whatsapp-for-linux # bad messenger
        insomnia # postman-alternative
        grim # whole screen screenshot
        grimblast # region screenshot
        libreoffice
        godot_4

        prismlauncher
        jdk17
        jdk8
        protonup-qt # easy ge-proton setup for steam

        swww
        pavucontrol # sound control
    ];

    stable-packages = with pkgs; [
        gnome.nautilus # file explorer
        gnome.cheese # camera

        fluent-gtk-theme
        orchis-theme

        # icon themes
        gnome.adwaita-icon-theme # just having this installed fixes issues with some apps
        catppuccin-cursors.macchiatoDark

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
}
