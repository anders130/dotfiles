{
    config,
    pkgs,
    ...
}: {
    modules = {
        ags.enable = true;
        programs.gui = {
            rofi.enable = true;
            swaync.enable = true;
            hyprlock = {
                enable = true;
                inherit (config.modules.desktop) mainMonitor;
            };
            swayosd.enable = true;
        };
    };

    environment.systemPackages = with pkgs.unstable; [
        swww
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
        grim # whole screen screenshot
        grimblast # region screenshot
    ];
}
