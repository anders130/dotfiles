{config, ...}: {
    virtualisation.oci-containers.containers.pairdrop = {
        image = "lscr.io/linuxserver/pairdrop:latest";
        autoStart = true;
        ports = ["3000:3000"];
        environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = config.time.timeZone;
            RATE_LIMIT = "false";
            WS_FALLBACK = "false";
            RTC_CONFIG = "";
            DEBUG_MODE = "false";
        };
    };
    services.caddy.virtualHosts."pairdrop.${config.networking.domain}".extraConfig = ''
        reverse_proxy :3000
    '';
    networking.firewall.allowedTCPPorts = [3000];
}
