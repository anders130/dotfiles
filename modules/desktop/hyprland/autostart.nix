{
    config,
    lib,
    ...
}: {
    hm.wayland.windowManager.hyprland.settings.exec-once = let
        afterFirstLogin = cmd: "while pgrep -x hyprlock > /dev/null; do sleep 0.5; done && ${cmd}";
    in
        [
            "swww-daemon" # wallpaper daemon
            "my-shell"
            "swaync" # notification daemon
            "swayosd-server"
            "hyprlock"
        ]
        ++ lib.mkAutostartList afterFirstLogin config.modules.desktop.autostart;
}
