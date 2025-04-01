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

    # mini network between nas and ds1
    networking.interfaces.enp7s0 = {
        useDHCP = false;
        ipv4.addresses = [{
            address = "192.168.2.1";
            prefixLength = 24;
        }];
    };
}
