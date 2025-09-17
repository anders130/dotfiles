{config, ...}: {
    hm.wayland.windowManager.hyprland.settings.exec-once = [
        "gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
        "hyprctl setcursor ${config.stylix.cursor.package.name} ${toString config.stylix.cursor.size}"
    ];
}
