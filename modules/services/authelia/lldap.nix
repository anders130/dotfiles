{
    config,
    lib,
    ...
}: let
    inherit (builtins) elemAt;
    inherit (lib.strings) splitString;
    inherit (config.networking) domain;
    baseDN = let dn = splitString "." domain; in "dc=${elemAt dn 0},dc=${elemAt dn 1}";
    port = 17170;
in {
    # sops.secrets.lldap.sopsFile = ./secrets.yaml;
    services.lldap = {
        enable = true;
        settings = {
            ldap_base_dn = baseDN;
            ldap_user_dn = "admin";
            ldap_user_email = "admin@${domain}";
            ldap_user_pass = "supersecret";

            jwt.secret = "verysecretjwtkeyhere";
            http = {
                inherit port;
                host = "127.0.0.1";
            };

            public_url = "https://ldap.${domain}";
            database_url = "sqlite://./users.db?mode=rwc";

            # smtp = {
            #     server = "smtp.${domain}";
            #     port = 587;
            #     encryption = "starttls";
            #     user = config.sops.secrets."lldap/smtp/user".path;
            #     password = config.sops.secrets."lldap/smtp/password".path;
            #     from = "LLDAP Admin <no-reply@${domain}>";
            # };
        };
    };
    systemd.tmpfiles.rules = [
        "d /var/lib/lldap 0755 lldap lldap -"
    ];
    services.caddy.virtualHosts."ldap.${domain}" = lib.mkReverseProxy {
        inherit port;
    };
}
