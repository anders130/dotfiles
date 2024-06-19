{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options = {
        modules.discord.enable = lib.mkEnableOption "discord";
    };

    config = lib.mkIf config.modules.discord.enable {
        environment.systemPackages = [
            (pkgs.unstable.vesktop.overrideAttrs (finalAttrs: previousAttrs: {
                desktopItems = [
                    ((builtins.elemAt previousAttrs.desktopItems 0).override { icon = "discord"; })
                ];
            }))
            pkgs.discord
        ];

        home-manager.users.${username} = {
            xdg.desktopEntries.discord = {
                name = "Discord";
                noDisplay = true;
            };
        };
    };
}
