{
    dots,
    inputs,
    ...
}: {
    flake-file.inputs.hyprland = {
        url = "github:hyprwm/hyprland/v0.56.2";
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

        homeManager = {lib, ...}: {
            imports = [inputs.hyprland.homeManagerModules.default];
            stylix.targets.hyprland.enable = false;
            wayland.windowManager.hyprland = {
                enable = true;
                xwayland.enable = true;
                package = null;
                portalPackage = null;
                systemd.variables = ["--all"];
                configType = "lua";
                settings.env = lib.optional (primaryGpuPci != "") {_args = ["AQ_DRM_DEVICES" "/dev/dri/hypr-primary"];};
            };
        };
    };
}
