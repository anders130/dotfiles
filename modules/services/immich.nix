{
    config,
    lib,
    ...
}: let
    inherit (lib) mkForce;
    mediaLocation = "/mnt/rackflix/appdata/immich";
    group = "nextcloud";
in {
    services.immich = {
        inherit mediaLocation group;
        enable = true;
        host = "::"; # allow IPv4 and IPv6
        accelerationDevices = ["/dev/dri/renderD128"];
    };
    modules.services.caddy.virtualHosts."immich.${config.networking.domain}" = {
        inherit (config.services.immich) port;
    };
    systemd = {
        services.immich-server.serviceConfig.UMask = mkForce "0027";
        tmpfiles.settings.immich = mkForce {
            ${config.services.immich.mediaLocation}.e = {
                inherit group;
                user = "immich";
                mode = "0750";
            };
        };
    };
}
