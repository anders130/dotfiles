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
            settings = {
                ApiKeySettings.ApiKey = "MySecretApiKey";
                LedControllerSettings.PixelCount = 200;
            };
        };
    };
}
