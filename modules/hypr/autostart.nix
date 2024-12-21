{
    lib,
    pkgs,
    ...
}: let
    autostart = cfg: pkgs.writeShellScriptBin "autostart" ''
        hyprctl dispatch movefocus r

        # only execute if noisetorch is not yet active (grep finds <= 1 results)
        if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
            sleep 1 && noisetorch -i
        fi

        # hardware stuff
        xrandr --output ${cfg.mainMonitor} --primary

        # apps
        ${lib.concatMapStringsSep "\n" (app: ''
            ${app.cmd} &
            ${
                if app.minimize && app.windowName != ""
                then /*bash*/''
                    sleep 3 &&
                    hyprctl clients | grep -q "${app.windowName or app.name}" &&
                    hyprctl dispatch closewindow ${app.windowName or app.name} &
                ''
                else ""
            }
        '')
        cfg.autostartApps}
    '';
in {
    config = cfg: {
        environment.systemPackages = [(autostart cfg)];
        hm.wayland.windowManager.hyprland.settings.exec-once = ["autostart"];
    };
}
