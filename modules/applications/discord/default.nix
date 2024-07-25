{
    config,
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
            (pkgs.unstable.vesktop.overrideAttrs (finalAttrs: previousAttrs: {
                desktopItems = [
                    ((builtins.elemAt previousAttrs.desktopItems 0).override {icon = "discord";})
                ];
            }))
            pkgs.discord
        ];

        home-manager.users.${username} = {
            xdg = {
                desktopEntries.discord = {
                    name = "Discord";
                    noDisplay = true;
                };

                configFile."vesktop/themes/catppuccin-macchiato.theme.css".text = /*css*/''
                    /**
                     * @name Catppuccin Macchiato
                     * @author winston#0001
                     * @authorId 505490445468696576
                     * @version 0.2.0
                     * @description 🎮 Soothing pastel theme for Discord
                     * @website https://github.com/catppuccin/discord
                     * @invite r6Mdz5dpFc
                     * **/

                    @import url("https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css");
                '';
            };
        };
    };
}
