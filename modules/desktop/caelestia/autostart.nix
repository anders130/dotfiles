{
    dots.desktop.provides.caelestia.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) mkOption mkIf types;
        waitForShell = ''
            while ! hyprctl layers | grep 'namespace: caelestia-background' | grep -qv 'pid: -1'; do
                sleep 0.1
            done
        '';
        lockOnStart = pkgs.writeShellScript "caelestia-lock-on-start" ''
            ${waitForShell}
            sleep 0.4
            hyprctl dispatch 'hl.dsp.global("caelestia:lock")'
        '';
    in {
        options.my.caelestia.lockOnStart = mkOption {
            type = types.bool;
            default = true;
            description = "lock the caelestia shell on first login";
        };
        config = mkIf config.my.caelestia.lockOnStart {
            my.hyprland.execOnce = ["${lockOnStart}"];
        };
    };
}
