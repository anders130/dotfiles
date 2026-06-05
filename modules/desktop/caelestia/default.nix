{dots, ...}: {
    flake-file.inputs = {
        caelestia-cli = {
            url = "github:caelestia-dots/cli";
            inputs = {
                caelestia-shell.follows = "caelestia-shell";
                nixpkgs.follows = "caelestia-shell/nixpkgs";
            };
        };
        caelestia-shell = {
            url = "github:caelestia-dots/shell";
            inputs.caelestia-cli.follows = "caelestia-cli";
        };
    };
    flake-follows.exclude = ["caelestia-shell.nixpkgs"];

    den.schema.host = {lib, ...}: {
        options.caelestia = {
            showNetwork = lib.mkEnableOption "show network status in caelestia bar";
            showAudio = lib.mkEnableOption "show audio switcher in caelestia bar";
        };
    };

    dots.desktop.provides.caelestia = {host, ...}: {
        includes = [dots.desktop.provides.hyprland];
        homeManager = {osConfig, ...}: {
            my.caelestia.status = {
                # tolerant reads: the den.schema.host declaration is in the
                # producer flake and doesn't travel the namespace, so consumers
                # that don't declare it fall back to false.
                showNetwork = host.caelestia.showNetwork or false;
                showAudio = host.caelestia.showAudio or false;
                showBluetooth = osConfig.hardware.bluetooth.enable;
                showBattery = osConfig.services.upower.enable && osConfig.services.power-profiles-daemon.enable;
            };
            wayland.windowManager.hyprland.settings = {
                general = {
                    gaps_in = 5;
                    gaps_out = 10;
                    border_size = 3;
                };
                decoration.rounding = 25;
                bindin = [
                    "Super, mouse:272, global, caelestia:launcherInterrupt"
                    "Super, mouse:273, global, caelestia:launcherInterrupt"
                    "Super, mouse:274, global, caelestia:launcherInterrupt"
                    "Super, mouse:275, global, caelestia:launcherInterrupt"
                    "Super, mouse:276, global, caelestia:launcherInterrupt"
                    "Super, mouse:277, global, caelestia:launcherInterrupt"
                    "Super, mouse_up, global, caelestia:launcherInterrupt"
                    "Super, mouse_down, global, caelestia:launcherInterrupt"
                ];
                layerrule = [
                    "animation fade, match:namespace hyprpicker"
                    "animation fade, match:namespace selection" # slurp
                    "animation fade, match:namespace wayfreeze"

                    # Fuzzel
                    "animation popin 80%, match:namespace launcher"
                    "blur true, match:namespace launcher"

                    # Shell
                    "no_anim true, match:namespace caelestia-(border-exclusion|area-picker)"
                    "animation fade, match:namespace caelestia-(drawers|background)"
                    "blur true, match:namespace caelestia-drawers"
                    "ignore_alpha 0.57, match:namespace caelestia-drawers"
                ];
                windowrule = [
                    "opaque true, match:class swappy|org.quickshell"
                    "center true, match:float true, match:xwayland false"
                    "float true, match:class org.quickshell|org.pulseaudio"
                ];
                cursor.hotspot_padding = 1;
            };
            # TODO: remove this once home-manager module supports this
            systemd.user.services.caelestia.Service.Environment = ["QT_QPA_PLATFORMTHEME=gtk3"];
        };
    };
}
