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
        google-chrome
        gnome.totem # video player
        signal-desktop # oss messenger
        whatsapp-for-linux # bad messenger

        prismlauncher
        jdk17
        jdk8
        protonup-qt # easy ge-proton setup for steam

        swww
        hyprlock # lock screen
        pavucontrol # sound control
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

    security.pam.services.swaylock = {};
}
