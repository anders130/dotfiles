{
    config,
    lib,
    ...
}: let
    cfg = config.modules.services.paperless;
in {
    options.modules.services.paperless = {
        enable = lib.mkEnableOption "paperless";
        domain = lib.mkOption {
            type = lib.types.str;
        };
    };

    config = lib.mkIf cfg.enable {
        services = {
            paperless = {
                enable = true;
                settings = {
                    PAPERLESS_OCR_LANGUAGE = "deu+eng";
                };
            };

            caddy = {
                enable = true;
                virtualHosts."${cfg.domain}:80".extraConfig = ''
                    tls internal
                    reverse_proxy http://localhost:28981 {
                        header_down Referer-Policy "strict-origin-when-cross-origin"
                    }
                '';
            };
        };

        networking.firewall.allowedTCPPorts = [
            80
            443
        ];
    };
}
