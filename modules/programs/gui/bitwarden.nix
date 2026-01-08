{pkgs, ...}: {
    environment.systemPackages = [pkgs.bitwarden-desktop];
    hm.wayland.windowManager.hyprland.settings.windowrule = [
        "no_screen_share true, match:class Bitwarden"
    ];
}
