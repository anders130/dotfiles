{config, ...}: {
    services.tautulli.enable = true;
    modules.services.caddy.virtualHosts."http://tautulli.${config.networking.hostName}" = {
        inherit (config.services.tautulli) port;
        local = true;
    };
}
