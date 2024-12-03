{
    pkgs,
    username,
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
        };
        __internal__.migrations.version = "3.3.6";
    };
in {
    environment.systemPackages = [pkgs.youtube-music];

    home-manager.users.${username}.home.activation.youtube-music-config = pkgs.lib.mkAfter ''
        config_dir="$HOME/.config/YouTube Music"
        mkdir -p "$config_dir"
        echo '${builtins.toJSON settings}' > "$config_dir/config.json"
    '';
}
