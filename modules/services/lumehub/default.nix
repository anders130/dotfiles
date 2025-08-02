{
    config,
    inputs,
    lib,
    ...
}: {
    imports = [inputs.lumehub.nixosModules.default];

    options.settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Settings for LumeHub (services.lumehub.settings)";
    };

    config = cfg: {
        services.lumehub = {
            enable = true;
            openFirewall = true;
            inherit (cfg) settings;
        };

        sops.secrets.lumehub_api_key.sopsFile = ./secrets.yaml;

        sops.templates."lumehub-secrets.json" = {
            path = "/var/lib/lumehub/appsettings.Production.json";
            content = builtins.toJSON {
                ApiKeySettings.ApiKey = config.sops.placeholder.lumehub_api_key;
            };
        };
    };
}
