{
    config,
    inputs,
    ...
}: {
    flake.nixosConfigurations = config.flake.lib.mkNixos "x86_64-linux" "jesse-desktop";
    flake.modules.nixos.jesse-desktop = {pkgs, ...}: {
        system.stateVersion = "24.05";
        hm.home.stateVersion = "24.05";

        networking.hostName = "jesse-desktop";

        imports = with config.flake.modules.nixos; [
            caelestia
            desktop

            dev

            openrgb

            kdeconnect
            obs
            winapps
        ];

        my = {
            caelestia.shell.showAudio = true;
            hyprland.autologinUser = "jesse";
            nix.daemon.enableLimit = true;
            desktop.autostart = [
                "sleep 2 && zapzap --hideStart"
                {
                    command = "bitwarden";
                    afterFirstLogin = true;
                }
            ];
        };

        hardware.bluetooth.enable = true;

        nix.settings.download-speed = 6250; # limit download speed to 50 Mbps

        environment.systemPackages = with pkgs; [
            plex-desktop
            (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.send-media.override {
                sshAddress = "admin@192.168.178.6";
            })
        ];

        home-manager.sharedModules = [
            ({config, ...}: {
                imports = with inputs.self.modules.homeManager; [nextcloud zapzap];
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
                        "/Photos" = mkFolder "Photos";
                        "/Music" = mkFolder "Music";
                        "/Videos" = mkFolder "Videos";
                    };
                };
            })
        ];
    };
}
