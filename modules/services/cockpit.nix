{
    config,
    lib,
    ...
}: let
    domain = "cockpit.${config.networking.hostName}";
in {
    services.cockpit = {
        enable = true;
        settings.WebService = {
            AllowUnencrypted = true;
            Origins = lib.mkForce "http://${domain} ws://${domain}";
            ProtocolHeader = "X-Forwarded-Proto";
        };
    };
    services.caddy.virtualHosts."http://${domain}" = lib.mkReverseProxy {
        inherit (config.services.cockpit) port;
    };
}
