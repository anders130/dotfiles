{
    modules = {
        bundles.server.enable = true;

        services = {
            blocky.enable = true;
            caddy.enable = true; # important for paperless and vaultwarden
            minecraft.enable = true;
            paperless.enable = true;
        };
    };

    networking.domain = "nebulon";

    services.samba = {
        enable = true;
        openFirewall = true;
        settings = {
            global = {
                "workgroup" = "WORKGROUP";
                "server string" = "smbnix";
                "netbios name" = "smbnix";
                "security" = "user";
                "hosts allow" = "192.168.178. 127.0.0.1 localhost";
                "hosts deny" = "0.0.0.0/0";
                "guest account" = "nobody";
                "map to guest" = "bad user";
            };
            root = {
                path = "/";
                browseable = "yes";
                "read only" = "no";
                "guest ok" = "yes";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "admin";
                "force group" = "users";
            };
        };
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.enableRedistributableFirmware = true;

    # prevent laptop from suspending when lid is closed
    services.logind.lidSwitchExternalPower = "ignore";

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
