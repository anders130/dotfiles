{
    dots.desktop.provides.hyprland.homeManager = {
        config,
        osConfig,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib) types mkOption getExe' optional concatStringsSep;
        inherit (lib.generators) mkLuaInline toLua;
        inherit (builtins) typeOf;
        awaitKeyring = pkgs.writeShellScript "await-keyring-unlock" ''
            busctl=${getExe' pkgs.systemd "busctl"}
            sleep=${getExe' pkgs.coreutils "sleep"}
            while [ "$("$busctl" --user get-property org.freedesktop.secrets \
                /org/freedesktop/secrets/collection/login \
                org.freedesktop.Secret.Collection Locked 2>/dev/null)" != "b false" ]; do
                "$sleep" 1
            done
        '';
        mkCmd = cmd:
            if typeOf cmd == "string"
            then cmd
            else let
                appCmd = cmd.command;
                gates = optional cmd.afterKeyringUnlock "${awaitKeyring}";
                inner = concatStringsSep " && " (gates ++ [appCmd]);
            in "${
                if cmd.delay > 0.0
                then "sleep ${toString cmd.delay} && "
                else ""
            }${inner}";
        mkStartHook = cmd: {
            _args = [
                "hyprland.start"
                (mkLuaInline "function() hl.exec_cmd(${toLua {} cmd}) end")
            ];
        };
    in {
        options.my.hyprland.execOnce = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Commands to run once on Hyprland startup (rendered as a Lua hl.on hook).";
        };
        config = {
            my.hyprland.execOnce = map mkCmd osConfig.my.desktop.autostart;
            wayland.windowManager.hyprland.settings.on = map mkStartHook config.my.hyprland.execOnce;
        };
    };
}
