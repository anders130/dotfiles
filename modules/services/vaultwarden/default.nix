{
    config,
    username,
    ...
}: let
    inherit (config.networking) domain;
    cfg = config.services.vaultwarden.config;
in {
    sops.secrets.vaultwarden = {
        sopsFile = ./secrets.env;
        format = "dotenv";
        owner = "vaultwarden";
        group = "vaultwarden";
    };

    services.vaultwarden = {
        enable = true;
        backupDir = "/mnt/rackflix/appdata/vaultwarden";
        environmentFile = config.sops.secrets.vaultwarden.path;
        config = {
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = 8222;
            WEBSOCKET_ENABLED = true;
            SIGNUPS_ALLOWED = false;
            DOMAIN = "https://vault.${domain}";
            SMTP_HOST = "smtp.strato.de";
            SMTP_PORT = 587;
            SMTP_FROM = "vaultwarden@${domain}";
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
    services.caddy.virtualHosts."vault.${domain}".extraConfig = ''
        encode zstd gzip
        reverse_proxy ${cfg.ROCKET_ADDRESS}:${toString cfg.ROCKET_PORT} {
            header_up X-Real-IP {remote_host}
        }
    '';
}
