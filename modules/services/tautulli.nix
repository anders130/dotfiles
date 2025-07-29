{
    config,
    lib,
    ...
}: {
    services.tautulli = {
        enable = true;
    };
    services.caddy.virtualHosts."http://tautulli.${config.networking.hostName}" = lib.mkReverseProxy {
        inherit (config.services.tautulli) port;
    };
}
