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

                discord = {
                    enable = false;
                    vencord.enable = false;
                };

                vesktop = {
                    enable = true;
                    package = pkgs.unstable.vesktop.overrideAttrs (finalAttrs: previousAttrs: {
                        desktopItems = [
                            ((builtins.elemAt previousAttrs.desktopItems 0).override {icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";})
                        ];
                    });
                };
            };
        };
    };
}
