{pkgs, ...}: {
    modules.desktop.hyprland-common.enable = true;
    hm = {
        home.packages = with pkgs; [
            caelestia-cli
            caelestia-shell
        ];
        wayland.windowManager.hyprland.settings = {
            general = {
                gaps_in = 5;
                gaps_out = 10;
                border_size = 3;
            };
            decoration.rounding = 20;
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
                "noanim, caelestia-(launcher|osd|notifications|border-exclusion|area-picker)"
                "animation fade, caelestia-(drawers|background)"
                "order 1, caelestia-border-exclusion"
                "order 2, caelestia-bar"
                "xray 1, caelestia-(border|launcher|bar|sidebar|navbar|mediadisplay|screencorners)"
                "blur, caelestia-.*"
                "blurpopups, caelestia-.*"
                "ignorealpha 0.57, caelestia-.*"
            ];
            windowrule = [
                "opacity 1, class:swappy"
            ];
        };
    };
    security.pam.services.caelestia.enableGnomeKeyring = true;
}
