{pkgs, ...}: {
    environment.systemPackages = [pkgs.bitwarden-desktop];
    hm.wayland.windowManager.hyprland.settings.windowrule = [
        "noscreenshare, class:Bitwarden"
    ];
}
