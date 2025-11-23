{
    config,
    lib,
    username,
    ...
}: let
    domain = "vault.${config.networking.domain}";
    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = 8222;
in {
    options.backupDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/vaultwarden/backup";
    };
    config = cfg: {
        sops.secrets.vaultwarden = {
            sopsFile = ./secrets.env;
            format = "dotenv";
            owner = "vaultwarden";
            group = "vaultwarden";
        };

        services.vaultwarden = {
            inherit (cfg) backupDir;
            enable = true;
            environmentFile = config.sops.secrets.vaultwarden.path;
            config = {
                inherit ROCKET_ADDRESS ROCKET_PORT;
                WEBSOCKET_ENABLED = true;
                SIGNUPS_ALLOWED = false;
                DOMAIN = "https://${domain}";
                SMTP_HOST = "smtp.strato.de";
                SMTP_PORT = 587;
                SMTP_FROM = "vaultwarden@${config.networking.domain}";
                SMTP_SECURITY = "starttls";
                EXPERIMENTAL_CLIENT_FEATURE_FLAGS = builtins.concatStringsSep "," [
                    "extension-refresh" # new ui in browser extension
                    # ssh-key-support
                    "fido2-vault-credentials"
                    "ssh-key-vault-item"
                    "ssh-agent"
                ];
            };
        };
        users.users.${username}.extraGroups = ["vaultwarden"];
        modules.services.caddy.virtualHosts.${domain} = {
            port = ROCKET_PORT;
            extraConfig = ''
                encode zstd gzip
            '';
            headers = ''
                header_up X-Real-IP {remote_host}
            '';
        };
    };
}
