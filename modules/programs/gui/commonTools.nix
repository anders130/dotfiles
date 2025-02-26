{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        bitwarden
        obsidian
        insomnia # postman-alternative
        libreoffice
        godot_4
        protonmail-desktop
        varia # download manager
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

        # work
        teams-for-linux
        jetbrains.idea-community
    ];

    services.xserver.excludePackages = [
        pkgs.xterm
    ];

    programs.noisetorch.enable = lib.mkDefault true;

    modules.programs.gui.signal-desktop.enable = lib.mkDefault true;
}
