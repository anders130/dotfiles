{config, ...}: let
    dbname = "nextcloud";
    dbuser = "nextcloud";
in {
    services = {
        postgresql = {
            enable = true;
            ensureDatabases = [dbname];
            ensureUsers = [
                {
                    name = dbuser;
                    ensureDBOwnership = true;
                }
            ];
        };
        nextcloud.config = {
            inherit dbname dbuser;
            dbtype = "pgsql";
            dbhost = "/run/postgresql";
            dbpassFile = config.sops.secrets."nextcloud/dbPass".path;
        };
    };
}
