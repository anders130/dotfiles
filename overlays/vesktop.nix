inputs: final: prev: {
    vesktop = prev.vesktop.overrideAttrs (_: {
        desktopItems = [
            (prev.makeDesktopItem {
                name = "discord";
                desktopName = "Discord";
                exec = "vesktop %U";
                icon = "${prev.discord}/share/icons/hicolor/256x256/apps/discord.png";
                startupWMClass = "Discord";
                genericName = "Internet Messenger";
                keywords = ["discord" "vencord" "vesktop"];
            })
        ];
    });
}
