{
    den,
    dots,
    ...
}: {
    den.hosts.x86_64-linux.workstation = {
        users.jesse = {};
        caelestia.showNetwork = true;
        hyprland.ttyAutostart = true;
    };
    den.aspects.workstation = {
        readme.intro = "This is the configuration for my work laptop.";
        includes = with den.aspects; [
            dots.desktop.provides.caelestia
            desktop

            dev
            work

            amdgpu
            displaylink
            fprint

            kdeconnect
            obs
            virt-manager
            nextcloud
            dots.desktop.provides.nwg-displays

            (den.batteries.tty-autologin "jesse")
        ];

        nixos = {
            system.stateVersion = "24.05";

            my = {
                desktop.monitors.eDP-1 = {
                    isMain = true;
                    resolution = "1920x1200";
                    refreshRate = 60;
                };
            };

            hardware.bluetooth.enable = true;

            services = {
                power-profiles-daemon.enable = true;
                upower.enable = true;
            };
        };

        homeManager = {
            config,
            lib,
            ...
        }: {
            programs.nextcloud = {
                enable = true;
                instance-url = "https://cloud.gollub.dev";
                user = "jesse";
                folder-sync = {
                    "/" = {
                        localPath = "${config.home.homeDirectory}/Nextcloud";
                        ignoreHiddenFiles = false;
                    };
                    "/Photos/Wallpapers" = {
                        localPath = "${config.home.homeDirectory}/Pictures/Wallpapers";
                        ignoreHiddenFiles = false;
                    };
                };
            };
            wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
                source = ./override.conf
            '';
            xdg.configFile."hypr/override.conf".source = ./hyprland.conf;
        };
    };
}
