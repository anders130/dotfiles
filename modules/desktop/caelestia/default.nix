{username, ...}: {
    modules.desktop.hyprland-common.enable = true;
    hm = {
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
                "opaque true, match:class swappy|org\.quickshell"
                "center true, match:float true, match:xwayland false"
                "float true, match:class org\.quickshell|org\.pulseaudio"
            ];
            cursor.hotspot_padding = 1;
        };
        # TODO: remove this once home-manager module supports this
        systemd.user.services.caelestia.Service.Environment = ["QT_QPA_PLATFORMTHEME=gtk3"];
    };
    security.pam.services.caelestia.enableGnomeKeyring = true;
    users.users.${username}.extraGroups = ["i2c"]; # needed for making the brightness slider work
}
