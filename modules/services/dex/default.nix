{
    config,
    lib,
    ...
}: let
    port = 5556;
    domain = "https://dex.${config.networking.domain}";
in {
    services.dex = {
        enable = true;
        settings = {
            issuer = domain;
            storage = {
                type = "sqlite3";
                config.file = "/var/lib/dex/dex.db";
            };
            # expiry = {
            #     signingKeys = "168h"; # JWT signing key lifetime
            #     idTokens = "24h"; # How long OIDC tokens are valid
            #     refreshTokens = "720h"; # For apps using refresh tokens
            # };
            web = {
                http = "127.0.0.1:${toString port}";
                cookieName = "dex-session";
                cookieSecure = true; # requires HTTPS
                cookieExpiry = "24h";
            };
            frontend = {
                issuer = domain;
                theme = "dark";
            };
            connectors = [
                {
                    type = "ldap";
                    id = "lldap";
                    name = "LLDAP";
                    config = {
                        host = "localhost:3890";
                        insecureNoSSL = true;
                        insecureSkipVerify = true;
                        bindDN = "uid=admin,ou=people,dc=gollub,dc=dev";
                        bindPW = "supersecret";
                        usernamePrompt = "Email";
                        userSearch = {
                            baseDN = "ou=people,dc=gollub,dc=dev";
                            filter = "(objectClass=person)";
                            username = "uid";
                            idAttr = "uid";
                            emailAttr = "mail";
                            nameAttr = "displayName";
                            preferredUsernameAttr = "uid";
                        };
                        groupSearch = {
                            baseDN = "ou=groups,dc=gollub,dc=dev";
                            filter = "(objectClass=groupOfUniqueNames)";
                            userMatchers = [
                                {
                                    userAttr = "DN";
                                    groupAttr = "member";
                                }
                            ];
                            nameAttr = "cn";
                        };
                    };
                }
            ];
        };
    };
    systemd.services.dex.serviceConfig = {
        # `dex.service` is super locked down out of the box, but we need some
        # place to write the SQLite database. This creates $STATE_DIRECTORY below
        # /var/lib/private because DynamicUser=true, but it gets symlinked into
        # /var/lib/dex inside the unit, so the config as above works.
        StateDirectory = "dex";
    };
    services.caddy.virtualHosts.${domain} = lib.mkReverseProxy {
        inherit port;
    };
}
