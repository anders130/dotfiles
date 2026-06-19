{
    den.aspects.youtube-music = {
        nixos.nixpkgs.overlays = [
            (_: prev: {
                pear-desktop = prev.pear-desktop.overrideAttrs (_: {
                    desktopItems = [
                        (prev.makeDesktopItem {
                            name = "youtube-music";
                            desktopName = "YT Music";
                            exec = "pear-desktop %U";
                            icon = "${prev.pear-desktop}/share/icons/hicolor/256x256/apps/pear-desktop.png";
                            startupWMClass = "com.github.th_ch.youtube_music";
                            genericName = "Music Player";
                            keywords = ["music" "YouTube" "YT Music" "pear-desktop"];
                            categories = ["Audio" "AudioVideo" "Player"];
                        })
                    ];
                });
            })
        ];
        homeManager = {
            config,
            pkgs,
            lib,
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
                __internal__.migrations.version = "3.11.0";
            };
            configFile = pkgs.writeText "youtube-music-config.json" (builtins.toJSON settings);
        in {
            home.packages = [pkgs.pear-desktop];
            home.activation.youtube-music-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
                install -Dm644 ${configFile} "${config.home.homeDirectory}/.config/YouTube Music/config.json"
            '';
        };
    };
}
