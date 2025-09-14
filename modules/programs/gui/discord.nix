{
    config,
    inputs,
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
                useSystemVencord = false;
                settings = {
                    minimizeToTray = "on";
                    discordBranch = "stable";
                    arRPC = "on";
                    splashColor = "#${config.lib.stylix.colors.base05}";
                    splashBackground = "#${config.lib.stylix.colors.base00}";
                    splashTheming = true;
                    checkUpdates = false;
                    disableMinSize = true;
                    tray = true;
                    hardwareAcceleration = true;
                    firstLaunch = false;
                };
            };
        };
    };
}
