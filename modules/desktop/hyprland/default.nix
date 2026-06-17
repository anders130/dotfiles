{
    dots,
    inputs,
    ...
}: {
    flake-file.inputs.hyprland = {
        url = "github:hyprwm/hyprland/v0.55.2";
        inputs.pre-commit-hooks.follows = "";
    };
    flake-follows.exclude = ["hyprland.nixpkgs"];

    dots.desktop.provides.hyprland = {
        includes = with dots.desktop.provides; [mime autostart];
        nixos = {pkgs, ...}: {
            programs.hyprland = {
                enable = true;
                xwayland.enable = true;
            };
            environment = {
                sessionVariables.NIXOS_OZONE_WL = "1";
                systemPackages = with pkgs; [
                    app2unit
                    qt5.qtwayland
                    qt6.qtwayland
                    hyprpicker
                    wl-clipboard
                ];
            };
            xdg.portal = {
                enable = true;
                xdgOpenUsePortal = true;
                config.hyprland.default = ["hyprland" "gtk"];
            };
        };

        homeManager = {config, ...}: {
            imports = [inputs.hyprland.homeManagerModules.default];
            stylix.targets.hyprland.enable = false;
            wayland.windowManager.hyprland = {
                enable = true;
                xwayland.enable = true;
                package = null;
                portalPackage = null;
                settings = {
                    general = {
                        layout = "dwindle";
                        allow_tearing = false;
                    };
                    dwindle.preserve_split = true;
                    ecosystem.no_update_news = true;
                    misc = {
                        focus_on_activate = true;
                        initial_workspace_tracking = 0;
                    };
                    exec-once = [
                        "hyprctl setcursor ${config.stylix.cursor.package.name} ${toString config.stylix.cursor.size}"
                    ];
                };
                systemd.variables = ["--all"];
                configType = "hyprlang";
            };
            xdg.configFile."hypr/xdph.conf".text = ''
                screencopy {
                    allow_token_by_default = true
                }
            '';
        };
    };
}
