_: afterFirstLogin:
map (cmd:
        if builtins.typeOf cmd == "string"
        then "uwsm app -- ${cmd}"
        else let
            cmd' = c: "${
                if cmd.delay > 0.0
                then "sleep ${toString cmd.delay} && "
                else ""
            }${
                if cmd.isApp
                then "uwsm app -- ${c}"
                else c
            }";
        in
            cmd' (
                if cmd.afterFirstLogin
                then afterFirstLogin cmd.command
                else cmd.command
            ))
