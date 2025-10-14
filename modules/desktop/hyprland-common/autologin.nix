{
    config,
    pkgs,
    username,
    ...
}: {
    programs.fish.loginShellInit = ''
        if not set -q HYPRLAND_INSTANCE_SIGNATURE && uwsm check may-start
            exec uwsm start default
        end
    '';
    # autologin only in tty1
    systemd.services."getty@tty1" = {
        overrideStrategy = "asDropin";
        serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --noclear --autologin ${username} %I $TERM"];
    };
}
