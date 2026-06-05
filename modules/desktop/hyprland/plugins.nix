{
    flake-file.inputs.hyprsplit = {
        url = "github:shezdy/hyprsplit";
        inputs.hyprland.follows = "hyprland";
    };
    dots.desktop.provides.hyprland.homeManager = {pkgs, ...}: {
        wayland.windowManager.hyprland = {
            plugins = [pkgs.hyprlandPlugins.hyprsplit];
            extraConfig = ''
                plugin {
                    hyprsplit {
                        num_workspaces = 10
                        persistent_workspaces = false
                    }
                }
            '';
        };
    };
}
