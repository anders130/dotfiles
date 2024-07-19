{
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    hyprlandPackage = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
    environment.systemPackages = with pkgs.unstable; [
        hyprlock # lock screen
        swww # wallpaper utility
    ];

    programs.hyprland = {
        enable = true;
        package = hyprlandPackage;
        xwayland.enable = true;
    };

    # boot into hyprland
    services.xserver = {
        displayManager.lightdm = {
            enable = true;
            greeter.package = hyprlandPackage;
        };
    };

    services.displayManager.autoLogin = {
        enable = true;
        user = username;
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
            enable = true;
            package = hyprlandPackage;
            xwayland.enable = true;

            plugins = [
                inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
            ];

            settings = {
                exec-once = [
                    "${pkgs.unstable.swww}/bin/swww-daemon & ags"
                    "~/.config/hypr/autostart.sh"
                    "${pkgs.unstable.hyprlock}/bin/hyprlock"
                ];

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
                    "$mod, V, togglefloating"
                    "$mod, F, fullscreen"
                    "$mod, S, togglesplit"
                    "$mod, P, pin"
                    # move focus with vim-like keybinds
                    "$mod, h, movefocus, l"
                    "$mod, l, movefocus, r"
                    "$mod, k, movefocus, u"
                    "$mod, j, movefocus, d"
                    # move clients with vim-like keybinds
                    "$mod SHIFT, h, movewindow, l"
                    "$mod SHIFT, l, movewindow, r"
                    "$mod SHIFT, k, movewindow, u"
                    "$mod SHIFT, j, movewindow, d"
                    # programs
                    "$mod, return, exec, alacritty" # terminal
                    "$mod, E, exec, nautilus" # file manager
                    "$mod, B, exec, firefox" # browser
                    "$mod, Space, exec, pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf" # application launcher
                    "$mod, Period, exec, rofi -modi emoji:rofimoji -show emoji" # emoji picker
                    "$mod, BACKSPACE, exec, hyprlock" # lock screen
                    "$mod SHIFT, S, exec, grimblast --freeze copy area" # select area to copy
                    "$mod, T, exec, ~/.config/hypr/shaders/switch-shader.sh" # switch screen-shader
                    "$mod, 34, exec, forceMouseToGame" # SUPER + Ü
                    # workspaces
                ] ++ (builtins.concatLists (builtins.genList (
                    x: let
                        ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
                    in [
                        "$mod, ${ws}, split-workspace, ${toString (x + 1)}"
                        "$mod Shift, ${ws}, split-movetoworkspace, ${toString (x + 1)}"
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

                general = {
                    layout = "dwindle";
                    allow_tearing = false;
                };
                dwindle.preserve_split = "yes";
                gestures.workspace_swipe = "off";
            };

            extraConfig = ''
                source = ./visuals/default.conf
                plugin {
                    split-monitor-workspaces {
                        count = 10
                        keep_focused = 0
                        enable_notifications = 0
                    }
                }
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
            "hypr/autostart.sh" = lib.mkSymlink {
                config = config;
                source = "hypr/autostart.sh";
            };
            "hypr/hyprlock.conf" = lib.mkSymlink {
                config = config;
                source = "hypr/hyprlock.conf";
            };
        };

        stylix.targets = {
            hyprland.enable = false;
            hyprpaper.enable = false;
        };
    };
}
