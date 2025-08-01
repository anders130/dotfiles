{
    inputs,
    lib,
    ...
}: {
    config = rec {
        programs.hyprland = {
            enable = true;
            withUWSM = true;
            xwayland.enable = true;
        };
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
            config.hyprland.default = [
                "hyprland"
                "gtk"
            ];
        };
        hm = {
            imports = [inputs.hyprland.homeManagerModules.default];
            stylix.targets.hyprland.enable = false;
            wayland.windowManager.hyprland = {
                inherit (programs.hyprland) enable xwayland;
                settings = {
                    general = {
                        layout = "dwindle";
                        allow_tearing = false;
                    };
                    dwindle.preserve_split = true;
                    gestures.workspace_swipe = false;
                    ecosystem.no_update_news = true;
                };
                extraConfig = "source = ./visuals/default.conf";
            };
            xdg.configFile = {
                "hypr/visuals" = lib.mkSymlink ./visuals;
                "hypr/shaders" = lib.mkSymlink ./shaders;
            };
        };
    };
}
