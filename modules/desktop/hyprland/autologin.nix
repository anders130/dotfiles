{
    # per-host capability: launch hyprland on tty login (pair with
    # den.batteries.tty-autologin for kiosk-style boot).
    den.schema.host = {lib, ...}: {
        options.hyprland.ttyAutostart = lib.mkEnableOption "launch hyprland on tty login";
    };

    # parametric on host; tolerant read so consumers without the schema default off
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
