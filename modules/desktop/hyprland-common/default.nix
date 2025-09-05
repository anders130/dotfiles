{
    inputs,
    lib,
    pkgs,
    ...
}: rec {
    programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
    };
    environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        systemPackages = with pkgs; [
            libsForQt5.qt5.qtwayland
            qt6.qtwayland
            hyprpicker # color picker
            wl-clipboard # clipboard manager for hyprpicker
        ];
    };
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
                # switches to browser when link is opened
                misc.focus_on_activate = true;
            };
            extraConfig = lib.toHyprlang {
                source = "./extra.conf";
            };
        };
        xdg.configFile = {
            "hypr/extra.conf" = lib.mkSymlink ./hyprland.conf;
            "hypr/xdph.conf".text = lib.toHyprlang {
                screencopy.allow_token_by_default = true;
            };
        };
    };
}
