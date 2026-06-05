{
    dots.desktop.provides.hyprland.homeManager = {
        config,
        osConfig,
        ...
    }: let
        mkCmd = cmd:
            if builtins.typeOf cmd == "string"
            then "app2unit -- ${cmd}"
            else let
                appCmd =
                    if cmd.isApp
                    then "app2unit -- ${cmd.command}"
                    else cmd.command;
                inner =
                    if cmd.afterFirstLogin && config.my.desktop.firstLoginHook != null
                    then "${config.my.desktop.firstLoginHook} && ${appCmd}"
                    else appCmd;
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
