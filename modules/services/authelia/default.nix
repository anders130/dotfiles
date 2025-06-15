{
    config,
    lib,
    ...
}: let
    inherit (config.networking) domain;
    port = 9091;
    secret = {
        sopsFile = ./secrets.yaml;
        owner = "authelia-default";
    };
in {
    sops.secrets = {
        "authelia/jwt_secret" = secret;
        "authelia/jwks" = secret;
        "authelia/hmac_secret" = secret;
        "authelia/session_secret" = secret;
        "authelia/storage_encryption_key" = secret;
        "authelia/lldap_authelia_password" = secret;
    };
    services.authelia.instances.default = {
        enable = true;
        settings = {
            theme = "dark";
            authentication_backend.ldap = {
                implementation = "lldap";
                address = "ldap://localhost:17170";
                base_dn = "dc=gollub,dc=dev";
                user = "uid=authelia,ou=people,dc=gollub,dc=dev";
            };
            access_control = {
                default_policy = "deny";
                rules = lib.mkAfter [
                    {
                        domain = "*.${domain}";
                        policy = "one_factor";
                    }
                ];
            };
            storage.local.path = "/var/lib/authelia/store";
            session = {
                # redis.host = "/var/run/redis-haddock/redis.sock";
                cookies = [
                    {
                        inherit domain;
                        authelia_url = "https://auth.${domain}";
                        # The period of time the user can be inactive for before the session is destroyed
                        inactivity = "1M";
                        # The period of time before the cookie expires and the session is destroyed
                        expiration = "3M";
                        # The period of time before the cookie expires and the session is destroyed
                        # when the remember me box is checked
                        remember_me = "1y";
                    }
                ];
            };
            notifier.smtp = {
                address = "smtp.strato.de:587";
                sender = "auth@${domain}";
            };
            log.level = "info";
            identity_providers.oidc = {
                cors = {
                    endpoints = ["token"];
                    allowed_origins_from_client_redirect_uris = true;
                };
                authorization_policies.default = {
                    default_policy = "one_factor";
                    rules = [
                        {
                            policy = "deny";
                            subject = "group:lldap_strict_readonly";
                        }
                    ];
                };
            };

            # Necessary for Caddy integration
            # See https://www.authelia.com/integration/proxies/caddy/#implementation
            server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };
        settingsFiles = [./oidc_clients.yaml];
        secrets = with config.sops; {
            jwtSecretFile = secrets."authelia/jwt_secret".path;
            oidcIssuerPrivateKeyFile = secrets."authelia/jwks".path;
            oidcHmacSecretFile = secrets."authelia/hmac_secret".path;
            sessionSecretFile = secrets."authelia/session_secret".path;
            storageEncryptionKeyFile = secrets."authelia/storage_encryption_key".path;
        };
        environmentVariables = with config.sops; {
            AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
                secrets."authelia/lldap_authelia_password".path;
            # AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = secrets.sendgrid-api-key-authelia.path;
        };
    };
    services.caddy = {
        virtualHosts."auth.${domain}" = lib.mkReverseProxy {
            inherit port;
        };
        # A Caddy snippet that can be imported to enable Authelia in front of a service
        # Taken from https://www.authelia.com/integration/proxies/caddy/#subdomain
        extraConfig = ''
            (auth) {
                forward_auth :${toString port} {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                }
            }
        '';
    };
}
