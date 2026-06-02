{
    config,
    inputs,
    ...
}: {
    nixpkgs.overlays = [
        (final: prev: {
            vesktop = prev.vesktop.overrideAttrs (_: {
                desktopItems = [
                    (prev.makeDesktopItem {
                        name = "discord";
                        desktopName = "Discord";
                        exec = "vesktop %U";
                        icon = "${prev.discord}/share/icons/hicolor/256x256/apps/discord.png";
                        startupWMClass = "vesktop";
                        genericName = "Internet Messenger";
                        keywords = ["discord" "vencord" "vesktop"];
                        categories = ["Network" "InstantMessaging" "Chat"];
                    })
                ];
            });
        })
    ];
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
                    MutualGroupDMs.enable = true;
                    BlurNSFW.enable = true;
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
                    firstLaunch = false;
                };
            };
        };
    };
}
