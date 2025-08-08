{
    config,
    inputs,
    pkgs,
    ...
}: rec {
    programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
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
        home.packages = [
            inputs.caelestia-cli.packages.${pkgs.system}.default
            inputs.caelestia.packages.${pkgs.system}.default
        ];
        wayland.windowManager.hyprland = {
            inherit (programs.hyprland) enable xwayland;
            settings = {
                general = {
                    layout = "dwindle";
                    allow_tearing = false;
                    gaps_in = 5;
                    gaps_out = 10;
                    border_size = 3;
                    "col.active_border" = "rgba(8aadf4ee)";
                    "col.inactive_border" = "rgba(494d64aa)";
                };
                decoration = {
                    rounding = 20;
                    blur = {
                        enabled = true;
                        ignore_opacity = true;
                        size = 10;
                        passes = 3;

                        brightness = 1;
                        contrast = 1.1;
                        noise = 1.17e-2;

                        new_optimizations = true;
                        xray = true;

                        popups = true;
                        popups_ignorealpha = 0.15;
                    };
                    shadow.enabled = false;
                };
                animations = {
                    enabled = true;
                    first_launch_animation = true;
                    bezier = [
                        "wind, 0.05, 0.9, 0.1, 1.05"
                        "winIn, 0.1, 1.1, 0.1, 1.1"
                        "winOut, 0.3, -0.3, 0, 1"
                        "liner, 1, 1, 1, 1"
                    ];
                    animation = [
                        "windows, 1, 6, wind, slide"
                        "windowsIn, 1, 6, winIn, slide"
                        "windowsOut, 1, 5, winOut, slide"
                        "windowsMove, 1, 5, wind, slide"
                        "border, 1, 1, liner"
                        "borderangle, 1, 30, liner, loop"
                        "fade, 1, 10, default"
                        "workspaces, 1, 5, wind"
                    ];
                };
                misc = {
                    force_default_wallpaper = 0;
                    disable_hyprland_logo = 1;
                    session_lock_xray = 1;
                };
                windowrule = let
                    default_opacity = "0.85 0.84"; # active and inactive opacity
                    blur_opacity = "0.99999997"; # for windows that set their own opacity
                in [
                    # make everything transparent
                    "opacity ${default_opacity}, class:.*"

                    # override transparency for specific apps
                    "opacity 1, class:totem"
                    ## firefox
                    "opacity ${blur_opacity}, class:firefox"
                    "opacity ${default_opacity}, class:firefox, initialTitle:Library"
                    ## zen browser
                    "opacity ${blur_opacity}, class:zen.*"
                    ## qutebrowser
                    "opacity ${blur_opacity}, class:org.qutebrowser.qutebrowser"

                    # termfilechooser centered and floated
                    "float, center, title:\'termfilechooser\'"
                    "size 70%, title:\'termfilechooser\'"

                    "opacity 1, class:com.github.rafostar.Clapper"
                ];

                dwindle.preserve_split = true;
                gestures.workspace_swipe = false;
                ecosystem.no_update_news = true;
                exec-once = let
                    tweaks = pkgs.writeShellScriptBin "tweaks" ''
                        hyprctl dispatch movefocus r
                        hyprctl setcursor ${config.stylix.cursor.package.name} ${toString config.stylix.cursor.size}
                    '';
                in [
                    "caelestia shell"
                    "gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
                    "autostart" # start all programs set in the desktop module
                    "${tweaks}/bin/tweaks"
                ];
            };
        };
    };
}
