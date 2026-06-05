{
    dots.desktop.provides.caelestia.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        waitForShell = pkgs.writeShellScript "wait-for-caelestia-shell" ''
            while ! hyprctl layers | grep 'namespace: caelestia-background' | grep -qv 'pid: -1'; do
                sleep 0.1
            done
        '';
        waitForFirstLogin = pkgs.writeShellScript "wait-for-first-login" ''
            while [ ! -f /tmp/hyprland/first_lock_done ]; do sleep 0.1; done
            rm -f /tmp/hyprland/first_lock_done
            while true; do
                output=$(caelestia shell lock isLocked) && [ "$output" = "false" ] && break
                sleep 0.5
            done
        '';
    in {
        options.my.caelestia.lockOnStart = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "lock the caelestia shell on first login";
        };
        config = lib.mkIf config.my.caelestia.lockOnStart {
            my.desktop.firstLoginHook = waitForFirstLogin;
            wayland.windowManager.hyprland.settings.exec-once = [
                "${waitForShell} && sleep 0.4 && hyprctl dispatch global caelestia:lock && mkdir -p /tmp/hyprland && touch /tmp/hyprland/first_lock_done"
            ];
        };
    };
}
