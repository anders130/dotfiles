{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.applications.discord = {
        enable = lib.mkEnableOption "discord";
    };

    config = lib.mkIf config.modules.applications.discord.enable {
        environment.systemPackages = [
            pkgs.discord
        ];

        home-manager.sharedModules = [
            inputs.nixcord.homeManagerModules.nixcord
        ];

        home-manager.users.${username} = {
            programs.nixcord = {
                enable = true;
                config = {
                    themeLinks = [
                        "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css"
                    ];
                    plugins = {
                        fakeNitro.enable = true;
                        pinDMs.enable = true;
                    };
                };

                discord.enable = false;
                vencord.enable = false;

                vesktop.enable = true;
                vesktopPackage = pkgs.unstable.vesktop.overrideAttrs (finalAttrs: previousAttrs: {
                    desktopItems = [
                        ((builtins.elemAt previousAttrs.desktopItems 0).override {icon = "discord";})
                    ];
                });
            };

            xdg.desktopEntries.discord = {
                name = "Discord";
                noDisplay = true;
            };
        };
    };
}
