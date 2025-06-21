{
    config,
    pkgs,
    ...
}: let
    tweaks = pkgs.writeShellScriptBin "tweaks" ''
        hyprctl dispatch movefocus r
        hyprctl setcursor ${config.stylix.cursor.package.name} ${toString config.stylix.cursor.size}
    '';
in {
    hm.wayland.windowManager.hyprland.settings.exec-once = [
        "swww-daemon" # wallpaper daemon
        "my-shell"
        "swaync" # notification daemon
        "swayosd-server"
        "gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
        "hyprlock"
        "autostart" # start all programs set in the desktop module
        "${tweaks}/bin/tweaks"
    ];
}
