{
    den.aspects.desktop = {
        nixos = {pkgs, ...}: {
            services.xserver.excludePackages = [pkgs.xterm];
            programs.noisetorch.enable = true;
            services.gnome.gnome-keyring.enable = true;
        };
        homeManager = {pkgs, ...}: {
            home.packages = with pkgs; [
                obsidian
                insomnia # postman-alternative
                godot_4

                pavucontrol # sound control

                snapshot # camera
                gnome-calculator
                bottles # windows programs

                clapper # video player
                loupe # image viewer
                decibels # audio player

                fluent-gtk-theme
                orchis-theme
            ];
            home.shellAliases.decibels = "org.gnome.Decibels";
            xdg.userDirs.setSessionVariables = false;

            my.desktop.windowRules.clapper = {
                match = "com.github.rafostar.Clapper";
                opacity = "opaque";
            };
        };
    };
}
