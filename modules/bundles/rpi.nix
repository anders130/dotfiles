{
    config,
    lib,
    ...
}: {
    options.bundles.rpi = {
        enable = lib.mkEnableOption "rpi bundle";
    };

    config = lib.mkIf config.bundles.rpi.enable {
        bundles.server.enable = true;

        networking = {
            networkmanager.enable = lib.mkForce false;
            useDHCP = false;
            interfaces = {
                wlan0.useDHCP = true;
                eth0.useDHCP = true;
            };
        };
    };
}
