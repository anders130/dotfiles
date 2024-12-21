{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: let
    package = (lib.getPkgs "hyprland").hyprland;
    portalPackage = (lib.getPkgs "hyprland").xdg-desktop-portal-hyprland;
    hyprlandPkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
    config = cfg: {
        programs.hyprland = {
            inherit package portalPackage;
            enable = true;
            xwayland.enable = true;
        };

        hardware.graphics = lib.mkIf config.modules.hardware.amdgpu.enable {
            package = hyprlandPkgs.mesa.drivers;
            package32 = hyprlandPkgs.pkgsi686Linux.mesa.drivers;
        };

        environment.systemPackages = with pkgs; [
            libsForQt5.qt5.qtwayland
            qt6.qtwayland
        ];

        hm = {
            imports = [inputs.hyprland.homeManagerModules.default];

            wayland.windowManager.hyprland = {
                inherit package;
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
    };
}
