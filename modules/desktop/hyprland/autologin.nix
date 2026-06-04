{
    flake.modules.nixos.hyprland = {
        config,
        lib,
        pkgs,
        ...
    }: {
        options.my.hyprland.autologinUser = lib.mkOption {
            type = lib.types.str;
            default = "";
        };
        config = lib.mkIf (config.my.hyprland.autologinUser != "") {
            programs.fish.loginShellInit = ''
                if not set -q HYPRLAND_INSTANCE_SIGNATURE
                    exec start-hyprland
                end
            '';
            systemd.services."getty@tty1" = {
                overrideStrategy = "asDropin";
                serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --noclear --autologin ${config.my.hyprland.autologinUser} %I $TERM"];
            };
        };
    };
}
