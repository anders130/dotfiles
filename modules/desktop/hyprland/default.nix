{
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    programs.hyprland = {
        package = pkgs.hyprland;
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
    };

    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
            common.default = ["gtk"];
            hyprland.default = [
                "gtk"
                "hyprland"
            ];
        };
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    services.xserver.displayManager.lightdm = {
        greeter.package = pkgs.hyprland;
        enable = lib.mkDefault true;
    };

    services.displayManager = {
        autoLogin = {
            enable = lib.mkDefault true;
            user = username;
        };
        defaultSession = lib.mkDefault "hyprland-uwsm";
    };

    hm = {
        imports = [inputs.hyprland.homeManagerModules.default];

        wayland.windowManager.hyprland = {
            package = pkgs.hyprland;
            enable = true;
            xwayland.enable = true;

            settings = {
                general = {
                    layout = "dwindle";
                    allow_tearing = false;
                };
                dwindle.preserve_split = "yes";
                gestures.workspace_swipe = "off";
            };

            extraConfig = /*hyprlang*/''
                source = ./visuals/default.conf
            '';

            # tell systemd to import environment by default (fixes screenshare)
            systemd.variables = ["--all"];
        };

        xdg.configFile."hypr/visuals" = lib.mkSymlink ./visuals;

        stylix.targets.hyprland.enable = false;
    };
}
