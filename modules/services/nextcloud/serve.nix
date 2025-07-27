{config, ...}: let
    domain = "cloud.${config.networking.domain}";
    fpm = config.services.phpfpm.pools.nextcloud;
in {
    services = {
        nextcloud = {
            hostName = domain;
            https = true;
            settings = {
                trusted_proxies = ["127.0.0.1" "::1"];
                forward_for_headers = ["X-Forwarded-For"];
            };
        };
        phpfpm.pools.nextcloud.settings = let
            inherit (config.services.caddy) user group;
        in {
            "listen.owner" = user;
            "listen.group" = group;
        };
        caddy.virtualHosts.${domain}.extraConfig = let
            inherit (config.services.nginx.virtualHosts.${domain}) root;
        in ''
            encode zstd gzip

            root * ${root}

            redir /.well-known/carddav /remote.php/dav 301
            redir /.well-known/caldav /remote.php/dav 301
            redir /.well-known/* /index.php{uri} 301
            redir /remote/* /remote.php{uri} 301

            header {
              Strict-Transport-Security max-age=31536000
              Permissions-Policy interest-cohort=()
              X-Content-Type-Options nosniff
              X-Frame-Options SAMEORIGIN
              Referrer-Policy no-referrer
              X-XSS-Protection "1; mode=block"
              X-Permitted-Cross-Domain-Policies none
              X-Robots-Tag "noindex, nofollow"
              -X-Powered-By
            }

            php_fastcgi unix/${fpm.socket} {
              root ${root}
              env front_controller_active true
              env modHeadersAvailable true
            }

            @forbidden {
              path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
              path /.* /autotest* /occ* /issue* /indie* /db_* /console*
              not path /.well-known/*
            }
            error @forbidden 404

            @immutable {
              path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
              query v=*
            }
            header @immutable Cache-Control "max-age=15778463, immutable"

            @static {
              path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
              not query v=*
            }
            header @static Cache-Control "max-age=15778463"

            @woff2 path *.woff2
            header @woff2 Cache-Control "max-age=604800"

            file_server
        '';
    };
}
