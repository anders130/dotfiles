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
            settings = {
                Logging.LogLevel = {
                    Default = "Information";
                    Microsoft.AspNetCore = "Warning";
                };
                AllowedHosts = "*";
                ConnectionStrings.DatabaseFileName = "LumeHub.Server.db";
                ApiKeySettings = {
                    ApiKey = "MySecretApiKey";
                    ApiKeyHeaderName = "x-api-key";
                    ApiKeySchemeName = "ApiKey";
                };
                LedControllerSettings = {
                    PixelCount = 100;
                    BusId = 0;
                    ClockFrequency = 2000000;
                };
            };
        };
    };
}
