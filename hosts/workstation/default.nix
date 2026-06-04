{
    config,
    inputs,
    ...
}: {
    flake.nixosConfigurations = config.flake.lib.mkNixos "x86_64-linux" "workstation";
    flake.modules.nixos.workstation = {lib, ...}: {
        system.stateVersion = "24.05";

        networking.hostName = "workstation";

        imports = with config.flake.modules.nixos; [
            caelestia
            desktop

            dev

            amdgpu
            displaylink
            openrgb

            kdeconnect
            obs
            winapps
        ];

        my = {
            caelestia.shell.showNetwork = true;
            hyprland.autologinUser = "jesse";
            desktop.monitors.eDP-1 = {
                isMain = true;
                resolution = "1920x1200";
                refreshRate = 60;
            };
        };

        hardware.bluetooth.enable = true;

        home-manager.sharedModules = [
            ({config, ...}: {
                imports = with inputs.self.modules.homeManager; [nextcloud nwg-displays];
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
            })
        ];

        services = {
            fprintd.enable = true;
            power-profiles-daemon.enable = true;
            upower.enable = true;
        };
    };
}
