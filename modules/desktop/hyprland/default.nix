{
    config,
    lib,
    pkgs,
    ...
}: let
    getMainMonitor = monitors: builtins.head (builtins.filter (m: m.value.isMain) (lib.attrsToList monitors));
in {
    modules = {
        ags.enable = true;
        hypr = {
            enable = true;
            mainMonitor = (getMainMonitor config.modules.desktop.monitors).name;
        };
        programs.gui = {
            rofi.enable = true;
            swaync.enable = true;
            hyprlock = {
                enable = true;
                mainMonitor = (getMainMonitor config.modules.desktop.monitors).name;
            };
        };
    };

    environment.systemPackages = with pkgs; [
        swww
    ];

    hm.wayland.windowManager.hyprland.settings.exec-once = [
        "swww-daemon" # wallpaper daemon
        "ags -b hypr" # widgets
        "swaync" # notification daemon
        "hyprlock" # lockscreen
        "rofi" # app launcher
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" # polkit
    ];
}
