{
    config,
    inputs,
    pkgs,
    ...
}: {
    hm = {
        imports = [inputs.nixcord.homeModules.nixcord];

        programs.nixcord = {
            enable = true;
            config = {
                themeLinks = [
                    "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css"
                ];
                plugins = {
                    fakeNitro.enable = true;
                    pinDMs.enable = true;
                    volumeBooster.enable = true;
                };
            };

            discord = {
                enable = false;
                vencord.enable = false;
            };

            vesktop = {
                enable = true;
                package = pkgs.vesktop.overrideAttrs (finalAttrs: previousAttrs: {
                    desktopItems = [
                        ((builtins.elemAt previousAttrs.desktopItems 0).override {icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";})
                    ];
                });
            };
        };

        home.file."${config.hm.programs.nixcord.vesktop.configDir}/settings.json" = {
            text = builtins.toJSON {
                discordBranch = "stable";
                minimizeToTray = true;
                arRPC = true;
                splashColor = "#${config.lib.stylix.colors.base05}";
                splashBackground = "#${config.lib.stylix.colors.base00}";
            };
            force = true;
        };
    };
}
