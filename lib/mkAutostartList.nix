_: afterFirstLogin:
map (cmd:
        if builtins.typeOf cmd == "string"
        then "app2unit -- ${cmd}"
        else let
            appCmd =
                if cmd.isApp
                then "app2unit -- ${cmd.command}"
                else cmd.command;
            inner =
                if cmd.afterFirstLogin
                then afterFirstLogin appCmd
                else appCmd;
        in "${
            if cmd.delay > 0.0
            then "sleep ${toString cmd.delay} && "
            else ""
        }${inner}")
