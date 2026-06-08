{dots, ...}: {
    dots.desktop.provides.mime = {
        includes = with dots.apps.provides; [
            clapper
            decibels
            loupe
            kitty
            nautilus
            zen-browser
        ];
        homeManager = {
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
            prog = name: "${builtins.head config.my.desktop.mime.${name}}.desktop";
        in {
            options.my.desktop.mime = {
                browser = mkProg ["zen-beta"];
                terminal = mkProg ["kitty"];
                fileManager = mkProg ["nautilus" "--new-window"];
                imageViewer = mkProg ["loupe"];
                videoPlayer = mkProg ["clapper"];
                musicPlayer = mkProg ["decibels"];
            };
            config.xdg.mimeApps.enable = true;
            config.xdg.mimeApps.defaultApplications = {
                "application/pdf" = prog "browser";
                "x-scheme-handler/http" = prog "browser";
                "x-scheme-handler/https" = prog "browser";
                "image/*" = prog "imageViewer";
                "video/*" = prog "videoPlayer";
                "audio/*" = prog "musicPlayer";
            };
        };
    };
}
