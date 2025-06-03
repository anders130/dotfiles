{config, ...}: let
    port = 9007;
    domain = "tandoor.${config.networking.domain}";
in {
    sops.secrets.tandoor = {
        sopsFile = ./secrets.env;
        format = "dotenv";
        owner = config.services.tandoor-recipes.user;
        inherit (config.services.tandoor-recipes) group;
    };
    systemd.services.tandoor-recipes.serviceConfig.EnvironmentFile = config.sops.secrets.tandoor.path;
    services = {
        tandoor-recipes = {
            inherit port;
            enable = true;
            address = "127.0.0.1";
            extraConfig = {
                ALLOWED_HOSTS = domain;
                DB_ENGINE = "django.db.backends.sqlite3";
                ENABLE_METRICS = 1;
                SOCIAL_DEFAULT_GROUP = "user";
                GUNICORN_MEDIA = "1";
            };
        };
        caddy.virtualHosts.${domain}.extraConfig = ''
            reverse_proxy :${toString port}
        '';
    };
}
