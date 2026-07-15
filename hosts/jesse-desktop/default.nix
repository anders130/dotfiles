{
    den,
    dots,
    ...
}: {
    den.hosts.x86_64-linux.jesse-desktop = {
        users.jesse = {};
        caelestia.showAudio = true;
        hyprland.ttyAutostart = true;
    };
    den.aspects.jesse-desktop = {
        readme.intro = "This is the configuration of my main computer.";
        includes = with den.aspects; [
            dots.desktop.provides.caelestia
            desktop
            termfilechooser

            dev
            work
            dots.gaming
            bottles

            kdeconnect
            winapps
            obs
            virt-manager
            zapzap
            nextcloud

            openrgb
            (den.batteries.tty-autologin "jesse")
        ];

        nixos = {
            pkgs,
            self',
            ...
        }: {
            system.stateVersion = "26.11";

            services.openssh.enable = true;

            my = {
                nix.daemon.enableLimit = true;
                desktop.autostart = [
                    "sleep 2 && zapzap --hideStart"
                    {
                        command = "bitwarden";
                        afterKeyringUnlock = true;
                    }
                ];
            };

            nix.settings.download-speed = 6250; # limit download speed to 50 Mbps

            environment.systemPackages = with pkgs; [
                plex-desktop
                (self'.packages.send-media.override {
                    sshAddress = "admin@192.168.178.6";
                })
            ];

            boot.kernel.sysctl = {
                "fs.inotify.max_user_watches" = 524288;
                "fs.inotify.max_user_instances" = 1024;
            };
        };

        homeManager = {config, ...}: {
            programs.nextcloud = {
                enable = true;
                instance-url = "https://cloud.gollub.dev";
                user = "jesse";
                folder-sync = let
                    mkFolder = f: {
                        localPath = "${config.home.homeDirectory}/${f}";
                        ignoreHiddenFiles = false;
                    };
                in {
                    "/Documents" = mkFolder "Documents";
                    "/Photos" = mkFolder "Pictures";
                    "/Music" = mkFolder "Music";
                    "/Videos" = mkFolder "Videos";
                };
            };
        };
    };
}
