{
    inputs,
    pkgs,
    ...
}: {
    hm = {
        imports = [inputs.nixcord.homeManagerModules.nixcord];

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
    };
}
