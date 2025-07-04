{
    loginShellInit = ''
        if not set -q HYPRLAND_INSTANCE_SIGNATURE && uwsm check may-start
            exec uwsm start default
        end
    '';
}
