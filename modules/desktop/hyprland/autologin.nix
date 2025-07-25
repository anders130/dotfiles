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
    # password prompt in graphical session
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = " This service will ensure that polkit-gnome-authentication-agent-1 is running. pkexec is recommended to be used instead of sudo.";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
        };
    };
}
