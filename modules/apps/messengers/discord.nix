{
    inputs,
    den,
    ...
}: {
    flake-file.inputs.nixcord.url = "github:kaylorben/nixcord";

    den.aspects.discord = {
        includes = [(den.batteries.insecure ["pnpm-10.29.2"]) den.aspects.desktop-entries];
        nixos = {pkgs, ...}: {
            my.desktop-entries.vesktop = {
                package = "vesktop";
                name = "discord";
                desktopName = "Discord";
                exec = "vesktop %U";
                icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";
                startupWMClass = "vesktop";
                genericName = "Internet Messenger";
                keywords = ["discord" "vencord" "vesktop"];
                categories = ["Network" "InstantMessaging" "Chat"];
            };
        };
        homeManager = {config, ...}: {
            imports = [inputs.nixcord.homeModules.nixcord];
            stylix.targets.nixcord.enable = false;
            programs.nixcord = {
                enable = true;
                config = {
                    themeLinks = [
                        "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css"
                    ];
                    plugins = {
                        fakeNitro.enable = true;
                        mutualGroupDms.enable = true;
                        blurNsfw.enable = true;
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
    };
}
