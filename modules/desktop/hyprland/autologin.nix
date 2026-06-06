{
    den.schema.host = {lib, ...}: {
        options.hyprland.ttyAutostart = lib.mkEnableOption "launch hyprland on tty login";
    };
    dots.desktop.provides.hyprland = {host, ...}: {
        nixos = {lib, ...}:
            lib.mkIf (host.hyprland.ttyAutostart or false) {
                programs.fish.loginShellInit = ''
                    if not set -q HYPRLAND_INSTANCE_SIGNATURE
                        exec start-hyprland
                    end
                '';
            };
    };
}
