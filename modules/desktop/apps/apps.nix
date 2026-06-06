{
    den.aspects.desktop = {
        # baseline desktop system toggles that aren't a domain of their own
        nixos = {pkgs, ...}: {
            services.xserver.excludePackages = [pkgs.xterm];
            programs.noisetorch.enable = true;
            services.gnome.gnome-keyring.enable = true;
        };
        # personal grab-bag of desktop apps that don't warrant their own aspect
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
        };
    };
}
