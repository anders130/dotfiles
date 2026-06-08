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

                fluent-gtk-theme
                orchis-theme
            ];
            xdg.userDirs.setSessionVariables = false;
        };
    };
}
