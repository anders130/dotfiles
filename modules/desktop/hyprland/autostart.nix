{pkgs, ...}: let
    tweaks = pkgs.writeShellScriptBin "tweaks" ''
        hyprctl dispatch movefocus r
    '';
in {
    hm.wayland.windowManager.hyprland.settings.exec-once = [
        "swww-daemon" # wallpaper daemon
        "ags -b hypr" # widgets
        "swaync" # notification daemon
        "hyprlock" # lockscreen
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" # polkit
        "autostart" # start all programs set in the desktop module
        "${tweaks}/bin/tweaks"
    ];
}
