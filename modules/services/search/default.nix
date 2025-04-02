{config, ...}: let
    cfg = config.services.searx.settings.server;
in {
    services.searx = {
        enable = true;
        environmentFile = config.sops.secrets.searx.path;
        limiterSettings = {
            real_ip = {
                x_for = 1;
                ipv4_prefix = 32;
                ipv6_prefix = 56;
            };
            botdetection.ip_limit = {
                filter_link_local = true;
                link_token = true;
            };
        };
        settings = {
            server = {
                bind_address = "127.0.0.1";
                port = 8888;
                secret_key = "@SEARX_SECRET_KEY@";
            };
            engines = [
                {
                    name = "google";
                    engine = "google";
                    shortcut = "g";
                    use_mobile_ui = true;
                }
            ];
        };
    };

    sops.secrets.searx = {
        sopsFile = ./secrets.env;
        format = "dotenv";
        owner = "searx";
        group = "searx";
    };

    services.caddy.virtualHosts."search.${config.networking.domain}".extraConfig = ''
        reverse_proxy http://${cfg.bind_address}:${toString cfg.port} {
            header_down Referer-Policy "strict-origin-when-cross-origin"
        }
    '';
}
