{
    lib,
    pkgs,
    username,
    ...
}: let
    inherit (lib) generators;
in {
    # whatsapp client
    environment.systemPackages = [pkgs.zapzap];
    modules.utils.initial-files = {
        enable = true;
        file."/home/${username}/.config/ZapZap/ZapZap.conf".text = generators.toINI {} {
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
        };
    };
}
