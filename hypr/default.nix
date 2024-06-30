{
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    # environment.systemPackages = with pkgs; [
    #     unstable.hyprlock # lock screen
    #     local.hyprsome # awesome-like workspaces
    # ];
    #
    # programs.hyprland = {
    #     enable = true;
    #     xwayland.enable = true;
    #     package = pkgs.hyprland;
    # };
    #
    # services.displayManager.defaultSession = "hyprland";

    services.greetd = {
        enable = true;
        settings = rec {
            initial_session = {
                command = "${pkgs.hyprland}/bin/Hyprland";
                user = username;
            };
            default_session = initial_session;
        };
    };

    # use gtk desktop portal
    # (recommended for usage alongside hyprland desktop portal)
    xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        config.common.default = "*"; # disable warning
    };

    home-manager.users.${username} = {config, ...}: {
        imports = [
            inputs.hyprland.homeManagerModules.default
        ];

        wayland.windowManager.hyprland = {
            enable = true;
            package = pkgs.hyprland;

            settings = {
                input = {
                    kb_layout = "de";
                    kb_variant = "";
                    kb_model = "";
                    kb_options = "";
                    kb_rules = "";

                    numlock_by_default = true;

                    follow_mouse = 1;
                    mouse_refocus = 0;

                    touchpad.natural_scroll = false;
                    sensitivity = 0;
                };

                "$mod" = "SUPER";
                bind = [
                    # essential keybinds
                    "$mod, C, killactive"
                    "$mod, M, exit"
                    "$mod, V, togglefloating"
                    "$mod, F, fullscreen"
                    "$mod, S, togglesplit"
                    "$mod, P, pin"
                    # # Move focus with vim-like keybinds
                    "$mod, h, movefocus, l"
                    "$mod, l, movefocus, r"
                    "$mod, k, movefocus, u"
                    "$mod, j, movefocus, d"
                    # programs
                    "$mod, return, exec, alacritty" # terminal
                    "$mod, E, exec, nautilus" # file manager
                    "$mod, B, exec, firefox" # browser
                    "$mod, Space, exec, pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf" # application launcher
                    "$mod, Period, exec, rofi -modi emoji:rofimoji -show emoji" # emoji picker
                    "$mod SHIFT, L, exec, hyprlock" # lock screen
                    "$mod SHIFT, S, exec, grimblast --freeze copy area" # select area to copy
                    "$mod, T, exec, ~/.dotfiles/other/screen-shader.sh" # switch screen-shader
                    # workspaces
                ] ++ (builtins.concatLists (builtins.genList (
                    x: let
                        ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
                    in [
                        "$mod, ${ws}, workspace, ${toString (x + 1)}"
                        "$mod Shift, ${ws}, movetoworkspace, ${toString (x + 1)}"
                    ]
                )10)) ++ [
                    # special workspaces
                    "$mod, D, togglespecialworkspace, magic"
                    "$mod SHIFT, D, movetoworkspace, special:magic"
                    "$mod, G, togglespecialworkspace, other"
                    "$mod SHIFT, G, movetoworkspace, special:other"
                ];

                bindm = [
                    # Move/resize windows with mainMod + LMB/RMB and dragging
                    "$mod, mouse:272, movewindow"
                    "$mod, mouse:273, resizewindow"
                ];
            };

            extraConfig = ''
                source = ./visuals/default.conf
                source = ./hardware.conf
            '';
        };

        xdg.configFile = {
            "hypr/shaders" = lib.mkSymlink {
                config = config;
                source = "hypr/shaders";
                recursive = true;
            };
            "hypr/visuals" = lib.mkSymlink {
                config = config;
                source = "hypr/visuals";
                recursive = true;
            };
            "hypr/hardware.conf" = lib.mkSymlink {
                config = config;
                source = "hypr/hardware.conf";
            };
        };

        stylix.targets = {
            hyprland.enable = false;
            hyprpaper.enable = false;
        };
    };
}
