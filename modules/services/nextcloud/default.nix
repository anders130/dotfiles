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
            settings = {
                default_phone_region = "DE";
                maintenance_window_start = 1;
                log_type = "file";
            };
            phpOptions = {
                "opcache.interned_strings_buffer" = "16";
                output_buffering = "off";
            };
            extraApps = {
                inherit
                    (pkgs.nextcloud31Packages.apps)
                    bookmarks
                    mail
                    # oidc_login
                    ;
                theming_customcss = pkgs.fetchNextcloudApp {
                    sha256 = "sha256-MsF+im9yCt7bRNIE8ait0wxcVzMXsHMNbp+IIzY/zJI=";
                    url = "https://github.com/nextcloud-releases/theming_customcss/releases/download/v1.18.0/theming_customcss.tar.gz";
                    license = "agpl3Only";
                };
            };
        };
        systemd.tmpfiles.settings."50-nextcloud".${cfg.datadir}.d = {
            user = "nextcloud";
            group = "nextcloud";
            mode = "0750";
        };
    };
}
