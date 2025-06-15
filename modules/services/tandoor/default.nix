{
    config,
    lib,
    ...
}: let
    port = 9007;
    domain = "tandoor.${config.networking.domain}";
    appConfig = {
        provider_id = "dex";
        name = "Dex";
        client_id = dexClient.id;
        secret = config.sops.placeholder."tandoor/oidc_secret";
        settings.server_url = "https://dex.${config.networking.domain}/.well-known/openid-configuration";
    };
    dexClient = {
        id = "tandoor";
        name = "Tandoor";
        redirectURIs = ["https://${domain}/accounts/oidc/${appConfig.provider_id}/login/callback/"];
        secretFile = config.sops.secrets."tandoor/oidc_secret".path;
        skipApprovalScreen = true;
    };
in {
    services.tandoor-recipes = {
        inherit port;
        enable = true;
        address = "127.0.0.1";
        extraConfig = {
            ALLOWED_HOSTS = domain;
            DB_ENGINE = "django.db.backends.sqlite3";
            ENABLE_METRICS = 1;
            GUNICORN_MEDIA = "1";
            SOCIAL_DEFAULT_GROUP = "user";
            SOCIALACCOUNT_AUTO_SIGNUP = true;
            ACCOUNT_EMAIL_VERIFICATION = "none";
            SOCIAL_PROVIDERS = "allauth.socialaccount.providers.openid_connect";
        };
    };
    services.caddy.virtualHosts.${domain} = lib.mkReverseProxy {
        inherit port;
    };
    sops = {
        secrets."tandoor/oidc_secret".sopsFile = ./secrets.yaml;
        templates.tandoor-social-providers.content = ''
            SOCIALACCOUNT_PROVIDERS='${builtins.toJSON {
                openid_connect = {
                    OAUTH_PKCE_ENABLED = "True";
                    APPS = [appConfig];
                };
            }}'
        '';
    };
    systemd.services.tandoor-recipes.serviceConfig.EnvironmentFile = config.sops.templates.tandoor-social-providers.path;
    services.dex.settings.staticClients = [dexClient];
}
