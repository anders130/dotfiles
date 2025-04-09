{config, ...}: {
    modules = {
        bundles.server.enable = true;
        services = {
            caddy.enable = true; # important for paperless and vaultwarden
            vaultwarden.enable = true;
            search.enable = true;
            jellyfin.enable = true;
            minecraft.enable = true;
            tmodloader = {
                enable = true;
                dataDir = "/mnt/rackflix/appdata/tModLoader";
                tmodloaderVersion = "v2025.02.3.0";
                motd = "NixOS Terraria Server";
                shutdownMessage = "Server is shutting down!";
                mods.enabled = [
                    2603400287 # Armor Modifiers & Reforging
                    3018274567 # Artificer's Accessories
                    2565540604 # Auto Trash
                    2669644269 # Boss Checklist
                    2824688266 # Calamity Music
                    2824688072 # Calamity
                    2802867430 # Fargo's Best of Both Worlds
                    2908170107 # absoluteAquarian Utilities
                    2563309347 # Magic Storage
                    2822990384 # Overlord Vanities
                    2982195397 # Pets Overhaul
                    2820025575 # Pylons Prevent Evils
                    2619954303 # Recipe Browser
                    2839001756 # Unofficial Calamity Whips
                ];
                maxPlayers = 3;
                world = {
                    name = "Gallifrey";
                    seed = "random";
                    size = "large";
                    difficulty = "master";
                };
            };
        };
    };

    services.caddy.virtualHosts."led.${config.networking.domain}".extraConfig = ''
        reverse_proxy http://192.168.178.85:5000
    '';

    networking = {
        domain = "gollub.dev";
        # mini network between nas and ds1
        interfaces.enp7s0 = {
            useDHCP = false;
            ipv4.addresses = [{
                address = "192.168.2.1";
                prefixLength = 24;
            }];
        };
    };

    boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
    };

    system.stateVersion = "24.11";
    hm.home.stateVersion = "24.11";
}
