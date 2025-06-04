{
    config,
    lib,
    ...
}: let
    cfg = config.services.searx.settings.server;
    inherit (config.networking) domain;
in {
    services.searx = {
        enable = true;
        redisCreateLocally = true;
        # Rate limiting
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
            general = {
                debug = false;
                instance_name = "SearXNG Instance";
                donation_url = false;
                contact_url = false;
                privacypolicy_url = false;
                enable_metrics = false;
            };
            server = {
                base_url = "https://search.${domain}";
                port = 8888;
                bind_address = "127.0.0.1";
                secret_key = config.sops.secrets.searx.path;
                limiter = true;
                public_instance = true;
                image_proxy = true;
                method = "GET";
            };
            outgoing = {
                request_timeout = 5.0;
                max_request_timeout = 15.0;
                pool_connections = 100;
                pool_maxsize = 15;
                enable_http2 = true;
            };
        };
    };

    sops.secrets.searx = {
        sopsFile = ./secrets.env;
        format = "dotenv";
        owner = "searx";
        group = "searx";
    };

    services.caddy.virtualHosts."search.${domain}" = lib.mkReverseProxy {
        inherit (cfg) port;
        headers = ''
            header_down Referer-Policy "strict-origin-when-cross-origin"
        '';
    };
}
