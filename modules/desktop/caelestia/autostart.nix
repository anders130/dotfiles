{
    dots.desktop.provides.caelestia.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        waitForShell = ''
            while ! hyprctl layers | grep 'namespace: caelestia-background' | grep -qv 'pid: -1'; do
                sleep 0.1
            done
        '';
        lockOnStart = pkgs.writeShellScript "caelestia-lock-on-start" ''
            ${waitForShell}
            sleep 0.4
            hyprctl dispatch global caelestia:lock
        '';
    in {
        options.my.caelestia.lockOnStart = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "lock the caelestia shell on first login";
        };
        config = lib.mkIf config.my.caelestia.lockOnStart {
            wayland.windowManager.hyprland.settings.exec-once = ["${lockOnStart}"];
        };
    };
}
