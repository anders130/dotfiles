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
                    trayMainOverride = true;
                    trayColorType = "custom";
                    trayAutoFill = "auto";
                    trayColor = "${config.lib.stylix.colors.red}";
                    firstLaunch = false;
                };
            };
        };
        xdg.configFile."vesktop/TrayIcons/icon_custom.png".source = ./tray-icon.png;
    };
}
