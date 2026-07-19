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

    den.schema.host = {lib, ...}: {
        options.hyprland.primaryGpuPci = lib.mkOption {
            type = lib.types.str;
            default = "";
        };
    };

    dots.desktop.provides.hyprland = {host, ...}: let
        primaryGpuPci = host.hyprland.primaryGpuPci or "";
    in {
        includes = with dots.desktop.provides; [mime autostart];
        nixos = {
            pkgs,
            lib,
            ...
        }: {
            services.udev.extraRules = lib.mkIf (primaryGpuPci != "") ''
                SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ENV{ID_PATH}=="pci-${primaryGpuPci}", SYMLINK+="dri/hypr-primary"
            '';
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

        homeManager = {
            config,
            lib,
            ...
        }: {
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
                    env =
                        lib.optional (primaryGpuPci != "")
                        "AQ_DRM_DEVICES,/dev/dri/hypr-primary";
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
