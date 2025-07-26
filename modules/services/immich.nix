{
    config,
    lib,
    ...
}: let
    mediaLocation = "/mnt/rackflix/appdata/immich";
in {
    services = {
        immich = {
            inherit mediaLocation;
            enable = true;
            host = "::"; # allow IPv4 and IPv6
            accelerationDevices = ["/dev/dri/renderD128"];
        };
        caddy.virtualHosts."immich.${config.networking.domain}" = lib.mkReverseProxy {
            inherit (config.services.immich) port;
        };
    };
    systemd.tmpfiles.settings.immich = lib.mkForce {
        ${config.services.immich.mediaLocation}.e = {
            user = "immich";
            group = "immich";
            mode = "0750";
        };
    };
}
