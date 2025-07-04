{
    nixosConfig,
    pkgs,
    ...
}: let
    tweaks = pkgs.writeShellScriptBin "tweaks" ''
        hyprctl dispatch movefocus r
        hyprctl setcursor ${nixosConfig.stylix.cursor.package.name} ${toString nixosConfig.stylix.cursor.size}
    '';
in [
    "swww-daemon" # wallpaper daemon
    "my-shell"
    "swaync" # notification daemon
    "swayosd-server"
    "gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
    "hyprlock"
    "autostart" # start all programs set in the desktop module
    "${tweaks}/bin/tweaks"
]
