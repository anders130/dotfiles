{config, ...}: {
    services.jellyseerr.enable = true;
    modules.services.caddy.virtualHosts."http://jellyseerr.${config.networking.hostName}" = {
        inherit (config.services.jellyseerr) port;
        local = true;
    };
}
