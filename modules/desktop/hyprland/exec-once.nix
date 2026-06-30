{
    dots.desktop.provides.hyprland.homeManager = {
        osConfig,
        pkgs,
        lib,
        ...
    }: let
        # polls the login keyring's Locked property (read-only, never triggers a prompt)
        awaitKeyring = pkgs.writeShellScript "await-keyring-unlock" ''
            busctl=${lib.getExe' pkgs.systemd "busctl"}
            sleep=${lib.getExe' pkgs.coreutils "sleep"}
            while [ "$("$busctl" --user get-property org.freedesktop.secrets \
                /org/freedesktop/secrets/collection/login \
                org.freedesktop.Secret.Collection Locked 2>/dev/null)" != "b false" ]; do
                "$sleep" 1
            done
        '';
        mkCmd = cmd:
            if builtins.typeOf cmd == "string"
            then "app2unit -- ${cmd}"
            else let
                appCmd =
                    if cmd.isApp
                    then "app2unit -- ${cmd.command}"
                    else cmd.command;
                gates = lib.optional cmd.afterKeyringUnlock "${awaitKeyring}";
                inner = lib.concatStringsSep " && " (gates ++ [appCmd]);
            in "${
                if cmd.delay > 0.0
                then "sleep ${toString cmd.delay} && "
                else ""
            }${inner}";
    in {
        wayland.windowManager.hyprland.settings.exec-once =
            map mkCmd osConfig.my.desktop.autostart;
    };
}
