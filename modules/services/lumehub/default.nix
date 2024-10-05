{
    config,
    inputs,
    lib,
    ...
}: {
    imports = [
        inputs.lumehub.nixosModules.default
    ];

    options.modules.services.lumehub = {
        enable = lib.mkEnableOption "lumehub service";
    };

    config = lib.mkIf config.modules.services.lumehub.enable {
        services.lumehub = {
            enable = true;
            openFirewall = true;
            settings.LedControllerSettings.PixelCount = 200;
        };

        sops.secrets.lumehub_api_key.sopsFile = ./secrets.yaml;

        sops.templates."lumehub-secrets.json" = {
            path = "/var/lib/lumehub/appsettings.Production.json";
            content = /*json*/''
            {
                "ApiKeySettings": {
                    "ApiKey": "${config.sops.placeholder.lumehub_api_key}"
                }
            }
            '';
        };
    };
}
