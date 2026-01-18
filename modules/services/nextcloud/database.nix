{config, ...}: let
    dbname = "nextcloud";
    dbuser = "nextcloud";
in {
    modules.services.postgresql.databases.${dbname} = {};
    services.nextcloud.config = {
        inherit dbname dbuser;
        dbtype = "pgsql";
        dbhost = "/run/postgresql";
        dbpassFile = config.sops.secrets."nextcloud/dbPass".path;
    };
}
