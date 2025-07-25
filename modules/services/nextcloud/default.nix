{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkOption types;
in {
    options.datadir = mkOption {
        type = types.str;
        default = "/var/lib/nextcloud";
    };
    config = cfg: {
        sops.secrets = let
            c = {
                mode = "0440";
                sopsFile = ./secrets.yaml;
                owner = "nextcloud";
            };
        in {
            "nextcloud/adminPass" = c;
            "nextcloud/dbPass" = c;
        };
        services.nextcloud = {
            inherit (cfg) datadir;
            enable = true;
            package = pkgs.nextcloud31;
            config = {
                adminuser = "admin";
                adminpassFile = config.sops.secrets."nextcloud/adminPass".path;
            };
        };
        systemd.tmpfiles.settings."50-nextcloud".${cfg.datadir}.d = {
            user = "nextcloud";
            group = "nextcloud";
            mode = "0750";
        };
    };
}
