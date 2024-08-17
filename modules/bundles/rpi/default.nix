{
    config,
    lib,
    username,
    ...
}: {
    options.bundles.rpi = {
        enable = lib.mkEnableOption "rpi bundle";
    };

    config = lib.mkIf config.bundles.rpi.enable {
        networking = {
            networkmanager.enable = lib.mkForce false;
            useDHCP = false;
            interfaces = {
                wlan0.useDHCP = true;
                eth0.useDHCP = true;
            };
        };

        security.pam.sshAgentAuth.enable = true;
        # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
        # a different host. not used in this tutorial, but handy later.
        nix.settings.trusted-users = [username];

        services.openssh.enable = true;
    };
}
