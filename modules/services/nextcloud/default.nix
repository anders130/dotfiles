{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkOption types;
    domain = "cloud.${config.networking.domain}";
    fpm = config.services.phpfpm.pools.nextcloud;
in {
    options.datadir = mkOption {
        type = types.str;
        default = "/var/lib/nextcloud";
    };
    config = cfg: {
        sops.secrets."nextcloud/adminPass" = {
            mode = "0440";
            sopsFile = ./secrets.yaml;
            owner = "nextcloud";
        };

        services.nextcloud = {
            inherit (cfg) datadir;
            enable = true;
            package = pkgs.nextcloud31;
            hostName = domain;
            https = true;

            config = {
                adminuser = "admin";
                adminpassFile = config.sops.secrets."nextcloud/adminPass".path;
                dbtype = "sqlite";
            };
        };

        systemd.tmpfiles.settings."50-nextcloud".${cfg.datadir}.d = {
            user = "nextcloud";
            group = "nextcloud";
            mode = "0750";
        };

        services.phpfpm.pools.nextcloud.settings = {
            "listen.owner" = config.services.caddy.user;
            "listen.group" = config.services.caddy.group;
        };

        services.caddy.virtualHosts.${domain}.extraConfig = ''
            encode zstd gzip

            root * ${config.services.nginx.virtualHosts.${domain}.root}

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
              root ${config.services.nginx.virtualHosts.${domain}.root}
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
