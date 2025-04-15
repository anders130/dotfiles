{lib, ...}: {
    services.caddy.enable = true;
    networking.firewall.allowedTCPPorts = [
        80
        443
    ];
    services.nginx.enable = lib.mkForce false;
}
