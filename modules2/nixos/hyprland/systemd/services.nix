{
    config,
    pkgs,
    username,
}: {
    # autologin only in tty1
    "getty@tty1" = {
        overrideStrategy = "asDropin";
        serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --noclear --autologin ${username} %I $TERM"];
    };
}
