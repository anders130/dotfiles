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
        "gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
        "autostart" # start all programs set in the desktop module
        "${tweaks}/bin/tweaks"
    ];
}