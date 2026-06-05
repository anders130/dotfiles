{den, ...}: {
    den.aspects.youtube-music = {
        includes = [den.aspects.initial-files];
        homeManager = {
            config,
            pkgs,
            ...
        }: let
            settings = {
                "window-size" = {
                    width = 612;
                    height = 1021;
                };
                "window-maximized" = false;
                "window-position" = {
                    x = 6660;
                    y = 51;
                };
                url = "https://music.youtube.com";
                options = {
                    tray = false;
                    appVisible = true;
                    autoUpdates = true;
                    alwaysOnTop = false;
                    hideMenu = true;
                    hideMenuWarned = true;
                    startAtLogin = false;
                    disableHardwareAcceleration = false;
                    removeUpgradeButton = false;
                    restartOnConfigChanges = false;
                    trayClickPlayPause = false;
                    autoResetAppCache = false;
                    resumeOnStart = false;
                    likeButtons = "";
                    proxy = "";
                    startingPage = "";
                    overrideUserAgent = false;
                    usePodcastParticipantAsArtist = false;
                    themes = [
                        (toString ./theme.css)
                    ];
                };
                plugins = {
                    notifications = {};
                    "video-toggle".mode = "custom";
                    "precise-volume".globalShortcuts = {};
                    discord.listenAlong = true;
                    synced-lyrics = {
                        enabled = true;
                        preferredProvider = "YTMusic";
                    };
                };
                __internal__.migrations.version = "3.3.6";
            };
        in {
            home.packages = [pkgs.pear-desktop];
            modules.initial-files.file."${config.home.homeDirectory}/.config/YouTube Music/config.json".text =
                builtins.toJSON settings;
        };
    };
}
