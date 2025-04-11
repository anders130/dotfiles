{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        unstable.bitwarden-desktop
        obsidian
        insomnia # postman-alternative
        libreoffice
        godot_4
        varia # download manager
        zapzap # whatsapp messenger

        pavucontrol # sound control

        snapshot # camera
        clapper # video player
        loupe # gnome image viewer
        gnome-calculator
        decibels # audio player
        bottles # windows programs

        fluent-gtk-theme
        orchis-theme

        # icon themes
        adwaita-icon-theme # just having this installed fixes issues with some apps

        # work
        teams-for-linux
        jetbrains.idea-community
    ];

    environment.shellAliases.decibels = "org.gnome.Decibels";

    services.xserver.excludePackages = [
        pkgs.xterm
    ];

    programs.noisetorch.enable = lib.mkDefault true;

    modules.programs.gui.signal-desktop.enable = lib.mkDefault true;
}
