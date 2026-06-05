{
    den.aspects.desktop.nixos = {pkgs, ...}: {
        services.xserver.excludePackages = [pkgs.xterm];
        programs.noisetorch.enable = true;
        services.gnome.gnome-keyring.enable = true;
    };
    den.aspects.desktop.homeManager = {pkgs, ...}: {
        home.packages = with pkgs; [
            obsidian
            insomnia # postman-alternative
            godot_4

            pavucontrol # sound control

            snapshot # camera
            clapper # video player
            loupe # gnome image viewer
            gnome-calculator
            decibels # audio player
            bottles # windows programs

            fluent-gtk-theme
            orchis-theme
        ];
        home.shellAliases.decibels = "org.gnome.Decibels";
        xdg.userDirs.setSessionVariables = false;
    };
}
