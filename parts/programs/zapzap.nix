{
    flake.modules.homeManager.zapzap = {
        config,
        lib,
        pkgs,
        ...
    }: let
        cfgFile = pkgs.writeText "ZapZap.conf" (lib.generators.toINI {} {
            notification.app = true;
            system = {
                background_message = false;
                donation_message = false;
                folderDownloads = false;
                hide_bar_users = false;
                menubar = false;
                notificationCounter = true;
                sidebar = false;
                tray_theme = "symbolic_light";
                wayland = true;
            };
            website.open_page = false;
        });
    in {
        home.packages = [pkgs.zapzap];
        home.activation.createZapZapConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
            dest="${config.home.homeDirectory}/.config/ZapZap/ZapZap.conf"
            if [ ! -e "$dest" ]; then
                mkdir -p "$(dirname "$dest")"
                cp ${cfgFile} "$dest"
            fi
        '';
    };
}
