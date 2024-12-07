{lib, ...}: {
    modules.bundles.server.enable = true;

    networking = {
        networkmanager.enable = lib.mkForce false;
        useDHCP = false;
        interfaces = {
            wlan0.useDHCP = true;
            eth0.useDHCP = true;
        };
    };
}
