{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.hypr;

    autostart = pkgs.writeShellScriptBin "autostart" ''
        hyprctl dispatch movefocus r

        # only execute if noisetorch is not yet active (grep finds <= 1 results)
        if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
            sleep 1 && noisetorch -i
        fi

        # hardware stuff
        xrandr --output ${cfg.mainMonitor} --primary

        # fix ssh agent
        if ssh-add -l | grep -q "The agent has no identities."; then
            for key in ~/.ssh/id_*; do
                if [[ -f $key && ! $key =~ \.pub$ ]]; then
                    ssh-add "$key"
                fi
            done
        else
            echo "SSH agent already has identities loaded."
        fi

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

    greeter = "hyprlock";
    polkit = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
in {
    config = lib.mkIf cfg.enable {
        environment.systemPackages = [
            autostart
        ] ++ (with pkgs.unstable; [
            swww # wallpaper utility
        ]);

        home-manager.users.${username} = {
            wayland.windowManager.hyprland = {
                settings.exec-once = [
                    "swww-daemon"
                    "ags -b hypr"
                    "${autostart}/bin/autostart"
                    greeter
                    polkit
                ];
            };
        };
    };
}
