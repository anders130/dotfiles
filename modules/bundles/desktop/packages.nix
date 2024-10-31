{
    config,
    lib,
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        bitwarden
        obsidian
        insomnia # postman-alternative
        grim # whole screen screenshot
        grimblast # region screenshot
        libreoffice
        godot_4
        protonmail-desktop
        signal-desktop # oss messenger
        zapzap # whatsapp messenger

        pavucontrol # sound control
    ];

    stable-packages = with pkgs; [
        snapshot # camera
        gnome.totem # video player
        loupe # gnome image viewer
        gnome.gnome-calculator
        gnome.gnome-music # music player
        bottles # windows programs
        rpi-imager

        fluent-gtk-theme
        orchis-theme

        # icon themes
        gnome.adwaita-icon-theme # just having this installed fixes issues with some apps

        gnome.dconf-editor # needed for home-manager gtk theming

        # work
        teams-for-linux
        jetbrains.idea-community
    ];
in {
    config = lib.mkIf config.bundles.desktop.enable {
        environment.systemPackages =
            stable-packages
            ++ unstable-packages;

        services.xserver.excludePackages = [
            pkgs.xterm
        ];

        programs.noisetorch.enable = true;
    };
}
