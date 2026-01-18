{config, ...}: let
    port = 9007;
    domain = "tandoor.${config.networking.domain}";
    dbname = "tandoor_recipes";
in {
    sops.secrets.tandoor = {
        sopsFile = ./secrets.env;
        format = "dotenv";
        owner = config.services.tandoor-recipes.user;
        inherit (config.services.tandoor-recipes) group;
    };
    systemd.services.tandoor-recipes.serviceConfig.EnvironmentFile = config.sops.secrets.tandoor.path;
    services.tandoor-recipes = {
        inherit port;
        enable = true;
        address = "127.0.0.1";
        extraConfig = {
            ALLOWED_HOSTS = domain;
            ENABLE_METRICS = 1;
            SOCIAL_DEFAULT_GROUP = "user";
            GUNICORN_MEDIA = "1";

            DB_ENGINE = "django.db.backends.postgresql";
            POSTGRES_HOST = "/run/postgresql";
            POSTGRES_PORT = config.services.postgresql.settings.port;
            POSTGRES_USER = dbname;
            POSTGRES_DB = dbname;
            TZ = config.time.timeZone;
        };
    };
    modules.services = {
        postgresql.databases.${dbname} = {};
        caddy.virtualHosts.${domain} = {
            inherit port;
        };
    };
}
