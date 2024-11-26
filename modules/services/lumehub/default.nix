{
    config,
    inputs,
    ...
}: {
    imports = [
        inputs.lumehub.nixosModules.default
    ];

    config = {
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
