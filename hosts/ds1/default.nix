{
    modules = {
        bundles.server.enable = true;

        services = {
            caddy.enable = true; # important for paperless
            paperless.enable = true;
        };
    };

    networking.domain = "ds1";

    boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
    };

    system.stateVersion = "24.11";
    hm.home.stateVersion = "24.11";
}
