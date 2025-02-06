{pkgs, ...}: {
    environment.systemPackages = [pkgs.nwg-displays];

    hm.wayland.windowManager.hyprland.settings.source = ["./monitors.conf"];
}
