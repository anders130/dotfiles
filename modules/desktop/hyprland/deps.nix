{
    config,
    pkgs,
    ...
}: {
    modules.programs.gui = {
        rofi.enable = true;
        swaync.enable = true;
        hyprlock = {
            enable = true;
            inherit (config.modules.desktop) mainMonitor;
        };
        swayosd.enable = true;
        xdg-desktop-portal-termfilechooser.enable = true;
    };

    environment.systemPackages = with pkgs; [
        swww
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
        grim # whole screen screenshot
        grimblast # region screenshot
        pkgs.local.wallpaper-selector # custom wallpaper selector using rofi and swww
        pkgs.local.shader-selector # custom shader selector using rofi and hyprland
        pkgs.inputs.my-shell.default
        hyprpicker # color picker
    ];
}
