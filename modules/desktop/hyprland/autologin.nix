{
    den.schema.host = {lib, ...}: {
        options.hyprland.ttyAutostart = lib.mkEnableOption "launch hyprland on tty login";
    };
    dots.desktop.provides.hyprland = {host, ...}: {
        nixos = {lib, ...}: let
            waitDevice =
                if (host.hyprland.primaryGpuPci or "") != ""
                then "/dev/dri/hypr-primary"
                else "/dev/dri/renderD128";
        in
            lib.mkIf (host.hyprland.ttyAutostart or false) {
                programs.fish.loginShellInit = ''
                    if not set -q HYPRLAND_INSTANCE_SIGNATURE; and test (tty) = /dev/tty1
                        while not test -e ${waitDevice}
                            sleep 0.1
                        end
                        exec start-hyprland
                    end
                '';
            };
    };
}
