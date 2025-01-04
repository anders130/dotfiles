{config, ...}: let
    stylixColors = config.lib.stylix.colors;
in {
    hm = {
        services.swayosd.enable = true;
        xdg.configFile."swayosd/style.css".text = /*css*/ ''
            window {
                background: rgba(${stylixColors.base00-rgb-r}, ${stylixColors.base00-rgb-g}, ${stylixColors.base00-rgb-b}, 0.6);
                border-radius: 12px;
                border: 2px solid #${stylixColors.base0D};
            }
        '';
    };
}
