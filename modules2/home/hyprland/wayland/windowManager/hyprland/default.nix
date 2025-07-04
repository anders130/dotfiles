{
    nixosConfig,
    pkgs,
}: {
    inherit (nixosConfig.programs.hyprland) enable package;
    xwayland.enable = true;

    plugins = [(pkgs.inputs.split-monitor-workspaces.default)];
    extraConfig =
        #hyprlang
        ''
            source = ./extraConfig/default.conf
            plugin {
                split-monitor-workspaces {
                    count = 10
                    keep_focused = 0
                    enable_notifications = 0
                    enable_persistent_workspaces = 0
                }
            }
        '';
}
