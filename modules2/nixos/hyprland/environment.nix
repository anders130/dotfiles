{pkgs}: {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
        swww
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
        grim # whole screen screenshot
        grimblast # region screenshot
        pkgs.local.wallpaper-selector # custom wallpaper selector using rofi and swww
        pkgs.inputs.my-shell.default
    ];
}
