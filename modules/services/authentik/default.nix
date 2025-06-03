{
    config,
    inputs,
    ...
}: let
    inherit (config.networking) domain;
in {
    imports = [inputs.authentik-nix.nixosModules.default];
    sops.secrets.authentik = {
        sopsFile = ./secrets.env;
        format = "dotenv";
    };
    services.authentik = {
        enable = true;
        environmentFile = config.sops.secrets.authentik.path;
        settings = {
            email = {
                host = "smtp.strato.de";
                port = 587;
                username = "auth@${domain}";
                use_tls = true;
                use_ssl = false;
                from = "auth@${domain}";
            };
            disable_startup_analytics = true;
            avatars = "initials";
        };
    };
    services.caddy.virtualHosts."auth.${domain}".extraConfig = ''
        reverse_proxy :9000
    '';
}
