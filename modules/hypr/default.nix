{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.hypr;
    package = (lib.getPkgs "hyprland").hyprland;
in {
    imports = [
        ./hyprlock
        ./shaders
        ./options.nix

        ./autostart.nix
        ./displayManager.nix
        ./keybinds.nix
        ./plugins.nix
    ];

    config = lib.mkIf cfg.enable {
        programs.hyprland = {
            inherit package;
            enable = true;
            xwayland.enable = true;
        };

        # use gtk desktop portal
        # (recommended for usage alongside hyprland desktop portal)
        xdg.portal = {
            enable = true;
            extraPortals = [pkgs.xdg-desktop-portal-gtk];
            config.commmon.default = "*";
        };

        home-manager.users.${username} = {config, ...}: {
            imports = [
                inputs.hyprland.homeManagerModules.default
            ];

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
            };

            xdg.configFile."hypr/visuals" = lib.mkSymlink {
                inherit config;
                source = "modules/hypr/visuals";
                recursive = true;
            };

            stylix.targets = {
                hyprland.enable = false;
                hyprpaper.enable = false;
            };
        };
    };
}
