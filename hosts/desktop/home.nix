{config, ...}: let
    symlink = config.lib.file.mkOutOfStoreSymlink;

    first_monitor = "DP-3";
    second_monitor = "DP-1";
    third_monitor = "DP-2";
in {
    home.file = {
        Documents.source = symlink "/mnt/data/Documents";
        Downloads.source = symlink "/mnt/data/Downloads";
        Music.source = symlink "/mnt/data/Music";
        Pictures.source = symlink "/mnt/data/Pictures";
        Videos.source = symlink "/mnt/data/Videos";
    };

    wayland.windowManager.hyprland.settings = {
        monitor = [
            "${second_monitor}, 3440x1440@144, 0x0, 1"
            "${third_monitor}, 1920x1080@144, 3440x0, 1"
            "${first_monitor}, 1920x1080@60, -1920x0, 1"
        ];

        workspace = [
            "${second_monitor}, 1"
            "${third_monitor}, 11"
            "${first_monitor}, 21"
        ];
    };
}
