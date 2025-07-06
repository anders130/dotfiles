{config, ...}: let
    inherit (config.networking) domain;
    firefly-domain = "firefly.${domain}";
    firefly-importer-domain = "firefly-importer.${domain}";
    fileServer = {package, socket}: ''
        root * ${package}/public
        file_server
        php_fastcgi unix/${socket}
    '';
in {
    sops.secrets.firefly-iii = {
        sopsFile = ./secrets.yaml;
        owner = config.services.firefly-iii.user;
        inherit (config.services.firefly-iii) group;
    };
    services = {
        firefly-iii = {
            enable = true;
            settings = {
                APP_KEY_FILE = config.sops.secrets.firefly-iii.path;
                TZ = config.time.timeZone;
                DB_CONNECTION = "sqlite";
                LOG_CHANNEL = "syslog";
                TRUSTED_PROXIES = "*";
                APP_URL = "https://${firefly-domain}";
                APP_ENV = "production";
            };
            inherit (config.services.caddy) user group;
        };
        firefly-iii-data-importer = {
            enable = true;
            virtualHost = firefly-importer-domain;
            settings = {
                FIREFLY_III_URL = "https://${firefly-domain}";
                FIREFLY_III_CLIENT_ID = 2;
            };
            inherit (config.services.caddy) user group;
        };
        caddy.virtualHosts = {
            "${firefly-domain}".extraConfig = fileServer {
                inherit (config.services.firefly-iii) package;
                inherit (config.services.phpfpm.pools.firefly-iii) socket;
            };
            "${firefly-importer-domain}".extraConfig = fileServer {
                inherit (config.services.firefly-iii-data-importer) package;
                inherit (config.services.phpfpm.pools.firefly-iii-data-importer) socket;
            };
        };
    };
}
