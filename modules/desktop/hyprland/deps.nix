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
        };
    };

    environment.systemPackages = with pkgs; [
        swww
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
    ];
}
