{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    hyprlandPackage = inputs.hyprland.packages.${pkgs.system}.hyprland;
    cfg = config.modules.hypr;

    autostart = "~/.config/hypr/autostart.sh";
    greeter = "hyprlock";
in {
    options.modules.hypr = {
        enable = lib.mkEnableOption "hypr";
        terminal = lib.mkOption {
            type = lib.types.str;
            default = "${pkgs.kitty}/bin/kitty";
        };
        appLauncher = lib.mkOption {
            type = lib.types.str;
            default = "pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs.unstable; [
            hyprlock # lock screen
            swww # wallpaper utility

            # apps
            signal-desktop # oss messenger
            whatsapp-for-linux # bad messenger
        ];

        programs.hyprland = {
            enable = true;
            package = hyprlandPackage;
            xwayland.enable = true;
        };

        # boot into hyprland
        services.xserver.displayManager.lightdm = {
            enable = true;
            greeter.package = hyprlandPackage;
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
                        "swww-daemon"
                        "ags -b hypr"
                        autostart
                        greeter
                        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
                        # apps
                        "whatsapp-for-linux"
                        "signal-desktop"
                    ];

                    input = {
                        kb_layout = "de";
                        kb_variant = "";
                        kb_model = "";
                        kb_options = "";
                        kb_rules = "";

                        numlock_by_default = true;
                        repeat_delay = 250;
                        repeat_rate = 25;

                        follow_mouse = 1;
                        mouse_refocus = 0;

                        touchpad.natural_scroll = false;
                        sensitivity = 0;
                    };

                    bind = let
                        e = "ags -b hypr";
                    in [
                        # ags stuff
                        "SUPER CTRL SHIFT, R, exec, ${e} quit; ${e}"
                        # essential keybinds
                        "SUPER, C, killactive"
                        "SUPER, V, togglefloating"
                        "SUPER, F, fullscreen"
                        "SUPER, S, togglesplit"
                        "SUPER, P, pin"
                        # move focus with vim-like keybinds
                        "SUPER, h, movefocus, l"
                        "SUPER, l, movefocus, r"
                        "SUPER, k, movefocus, u"
                        "SUPER, j, movefocus, d"
                        # move clients with vim-like keybinds
                        "SUPER SHIFT, h, movewindow, l"
                        "SUPER SHIFT, l, movewindow, r"
                        "SUPER SHIFT, k, movewindow, u"
                        "SUPER SHIFT, j, movewindow, d"
                        # programs
                        "SUPER, return, exec, ${cfg.terminal}" # terminal
                        "SUPER, E, exec, nautilus" # file manager
                        "SUPER, B, exec, firefox" # browser
                        "SUPER, Space, exec, ${cfg.appLauncher}"
                        "SUPER, Period, exec, rofi -modi emoji:rofimoji -show emoji" # emoji picker
                        "SUPER, BACKSPACE, exec, hyprlock" # lock screen
                        "SUPER SHIFT, S, exec, grimblast --freeze copy area" # select area to copy
                        "SUPER, T, exec, ~/.config/hypr/shaders/switch-shader.sh" # switch screen-shader
                        "SUPER, 34, exec, forceMouseToGame" # SUPER + Ü
                        # workspaces
                    ] ++ (builtins.concatLists (builtins.genList (
                        x: let
                            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
                        in [
                            "SUPER, ${ws}, split-workspace, ${toString (x + 1)}"
                            "SUPER Shift, ${ws}, split-movetoworkspace, ${toString (x + 1)}"
                        ]
                    )10)) ++ [
                        # special workspaces
                        "SUPER, D, togglespecialworkspace, magic"
                        "SUPER SHIFT, D, movetoworkspace, special:magic"
                        "SUPER, G, togglespecialworkspace, other"
                        "SUPER SHIFT, G, movetoworkspace, special:other"
                    ];

                    bindm = [
                        # Move/resize windows with mainMod + LMB/RMB and dragging
                        "SUPER, mouse:272, movewindow"
                        "SUPER, mouse:273, resizewindow"
                    ];

                    general = {
                        layout = "dwindle";
                        allow_tearing = false;
                    };
                    dwindle.preserve_split = "yes";
                    gestures.workspace_swipe = "off";
                };

                extraConfig = /*hyprlang*/''
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
                    source = "modules/hypr/shaders";
                    recursive = true;
                };
                "hypr/visuals" = lib.mkSymlink {
                    config = config;
                    source = "modules/hypr/visuals";
                    recursive = true;
                };
                "hypr/autostart.sh" = lib.mkSymlink {
                    config = config;
                    source = "modules/hypr/autostart.sh";
                };
                "hypr/hyprlock.conf" = lib.mkSymlink {
                    config = config;
                    source = "modules/hypr/hyprlock.conf";
                };
            };

            stylix.targets = {
                hyprland.enable = false;
                hyprpaper.enable = false;
            };
        };
    };
}
