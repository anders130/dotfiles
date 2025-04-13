{config, ...}: let
    domain = "obsidian.${config.networking.domain}";
    port = 5984;
in {
    sops.secrets.obsidian = {
        owner = config.services.couchdb.user;
        group = config.services.couchdb.group;
        mode = "440";
        sopsFile = ./secrets.yaml;
    };

    services.couchdb = {
        inherit port;
        enable = true;
        configFile = config.sops.secrets.obsidian.path;
        # https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md#configure
        extraConfig = ''
            [couchdb]
            single_node=true
            max_document_size = 50000000

            [chttpd]
            require_valid_user = true
            max_http_request_size = 4294967296
            enable_cors = true

            [chttpd_auth]
            require_valid_user = true
            authentication_redirect = /_utils/session.html

            [httpd]
            WWW-Authenticate = Basic realm="couchdb"
            enable_cors = true

            [cors]
            origins = app://obsidian.md,capacitor://localhost,http://localhost,https://localhost,capacitor://${domain},http://${domain},https://${domain}
            credentials = true
            headers = accept, authorization, content-type, origin, referer
            methods = GET,PUT,POST,HEAD,DELETE
            max_age = 3600
        '';
    };
    services.caddy.virtualHosts.${domain}.extraConfig = ''
        reverse_proxy :${toString port}
    '';
}
