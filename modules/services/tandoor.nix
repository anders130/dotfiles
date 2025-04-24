{config, ...}: let
    port = 9007;
    domain = "tandoor.${config.networking.domain}";
in {
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
