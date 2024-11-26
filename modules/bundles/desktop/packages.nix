{
    config,
    lib,
    pkgs,
    ...
}: {
    config = lib.mkIf config.modules.bundles.desktop.enable {
        environment.systemPackages = with pkgs; [
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

            snapshot # camera
            totem # video player
            loupe # gnome image viewer
            gnome-calculator
            gnome-music # music player
            bottles # windows programs
            rpi-imager

            fluent-gtk-theme
            orchis-theme

            # icon themes
            adwaita-icon-theme # just having this installed fixes issues with some apps

            dconf-editor # needed for home-manager gtk theming

            # work
            teams-for-linux
            jetbrains.idea-community
        ];

        services.xserver.excludePackages = [
            pkgs.xterm
        ];

        programs.noisetorch.enable = true;
    };
}
