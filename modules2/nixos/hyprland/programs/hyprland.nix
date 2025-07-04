{pkgs}: {
    enable = true;
    package = pkgs.hyprland;
    withUWSM = true;
    xwayland.enable = true;
}
