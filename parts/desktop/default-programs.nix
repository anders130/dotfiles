{
    flake.modules.homeManager.desktop = {
        config,
        lib,
        ...
    }: let
        inherit (lib) mkOption types;
        mkProg = default:
            mkOption {
                type = types.listOf types.str;
                inherit default;
            };
        prog = name: "${builtins.head config.my.desktop.defaultPrograms.${name}}.desktop";
    in {
        options.my.desktop.defaultPrograms = {
            browser = mkProg ["zen-beta"];
            terminal = mkProg ["kitty"];
            editor = mkProg ["nvim"];
            fileManager = mkProg ["nautilus" "--new-window"];
            imageViewer = mkProg ["loupe"];
            videoPlayer = mkProg ["clapper"];
            musicPlayer = mkProg ["decibels"];
        };
        config.xdg.mimeApps.defaultApplications = {
            "application/pdf" = prog "browser";
            "x-scheme-handler/http" = prog "browser";
            "x-scheme-handler/https" = prog "browser";
            "image/*" = prog "imageViewer";
            "video/*" = prog "videoPlayer";
            "audio/*" = prog "musicPlayer";
            "text/*" = prog "editor";
        };
    };
}
