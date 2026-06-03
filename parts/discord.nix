{inputs, ...}: let
    nixcordModule = {config, ...}: {
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
in {
    flake-file.inputs.nixcord.url = "github:kaylorben/nixcord";

    flake = {
        overlays.vesktop = _: prev: {
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
        };
        modules.nixos.discord = {
            nixpkgs.overlays = [inputs.self.overlays.vesktop];
            home-manager.sharedModules = [nixcordModule];
        };
        modules.homeManager.discord = {
            nixpkgs.overlays = [inputs.self.overlays.vesktop];
            imports = [nixcordModule];
        };
    };
}
