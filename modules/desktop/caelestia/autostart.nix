{
    config,
    lib,
    ...
}: {
    hm.wayland.windowManager.hyprland.settings.exec-once = let
        afterShellStarted = cmd: "while ! hyprctl layers | grep 'namespace: caelestia-background' | grep -qv 'pid: -1'; do sleep 0.1; done && ${cmd}";
        afterFirstLogin = cmd: "bash -c 'while [ ! -f /tmp/hyprland/first_lock_done ]; do sleep 0.1; done; rm -f /tmp/hyprland/first_lock_done; while true; do if output=$(caelestia shell lock isLocked); then if [ \"$output\" = \"false\" ]; then break; fi; fi; sleep 0.5; done && ${cmd}'";
    in
        [
            (afterShellStarted "sleep 0.3 && hyprctl dispatch global caelestia:lock && mkdir -p /tmp/hyprland && touch /tmp/hyprland/first_lock_done")
        ]
        ++ lib.mkAutostartList afterFirstLogin config.modules.desktop.autostart;
}
