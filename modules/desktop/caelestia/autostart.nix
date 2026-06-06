{
    dots.desktop.provides.caelestia.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        marker = "$XDG_RUNTIME_DIR/caelestia-first-lock-done";
        waitForShell = ''
            while ! hyprctl layers | grep 'namespace: caelestia-background' | grep -qv 'pid: -1'; do
                sleep 0.1
            done
        '';
        lockOnStart = pkgs.writeShellScript "caelestia-lock-on-start" ''
            ${waitForShell}
            sleep 0.4
            hyprctl dispatch global caelestia:lock
            touch "${marker}"
        '';
        waitForFirstLogin = pkgs.writeShellScript "wait-for-first-login" ''
            while [ ! -f "${marker}" ]; do sleep 0.1; done
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
            wayland.windowManager.hyprland.settings.exec-once = ["${lockOnStart}"];
        };
    };
}
