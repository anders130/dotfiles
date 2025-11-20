{
    config,
    lib,
    ...
}: let
    domain = "ntfy.${config.networking.domain}";
    port = 2586;
in {
    services = {
        ntfy-sh = {
            enable = true;
            settings = {
                auth-default-access = "deny-all";
                base-url = "https://${domain}";
                listen-http = ":${toString port}";
                behind-proxy = true;
                auth-users = [
                    "jesse:$2b$10$x9ZjMlkRBvh8u5ga5.dQ.OCs06iQhOqQEsGsHt4wv5VfuMbWDYMxK:admin"
                ];
                enable-login = true;
            };
        };
        caddy.virtualHosts.${domain} = lib.mkReverseProxy {
            inherit port;
            extraConfig = ''
                @httpget {
                    protocol http
                    method GET
                    path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
                }
                redir @httpget https://{host}{uri}
            '';
        };
    };
}
