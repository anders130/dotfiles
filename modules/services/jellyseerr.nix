{
    config,
    lib,
    ...
}: {
    services = {
        jellyseerr.enable = true;
        caddy.virtualHosts."http://jellyseerr.${config.networking.hostName}" = lib.mkReverseProxy {
            inherit (config.services.jellyseerr) port;
        };
    };
}
