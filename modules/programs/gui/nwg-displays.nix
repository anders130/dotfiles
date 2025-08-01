{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = [pkgs.nwg-displays];
    hm.wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
        source = ./monitors.conf
    '';
}
