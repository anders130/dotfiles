{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    environment.systemPackages = with pkgs; [
        obsidian
        insomnia # postman-alternative
        libreoffice
        godot_4
        varia # download manager

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
    ];

    environment.shellAliases.decibels = "org.gnome.Decibels";

    services.xserver.excludePackages = [pkgs.xterm];

    programs.noisetorch.enable = mkDefault true;

    modules.programs.gui = {
        bitwarden.enable = mkDefault true;
        signal-desktop.enable = mkDefault true;
    };
}
