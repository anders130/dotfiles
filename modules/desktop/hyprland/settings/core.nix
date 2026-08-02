{
    dots.desktop.provides.hyprland.homeManager = {config, ...}: {
        wayland.windowManager.hyprland.settings.config = {
            general = {
                layout = "dwindle";
                allow_tearing = false;
            };
            dwindle.preserve_split = true;
            ecosystem.no_update_news = true;
            misc = {
                focus_on_activate = true;
                initial_workspace_tracking = 0;
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                session_lock_xray = true;
            };
        };
        my.hyprland.execOnce = [
            "hyprctl setcursor ${config.stylix.cursor.package.name} ${toString config.stylix.cursor.size}"
        ];
    };
}
