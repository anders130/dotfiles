{den, ...}: {
    den.aspects.zapzap = {
        includes = [den.aspects.initial-files];
        homeManager = {
            config,
            lib,
            pkgs,
            ...
        }: {
            home.packages = [pkgs.zapzap];
            modules.initial-files.file."${config.home.homeDirectory}/.config/ZapZap/ZapZap.conf".text = lib.generators.toINI {} {
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
    };
}
