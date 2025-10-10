{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: {
    options.shell = {
        showNetwork = lib.mkEnableOption "Show network status";
        showAudio = lib.mkEnableOption "Show audio switcher";
    };
    config = cfg: {
        hm = {
            imports = [inputs.caelestia-shell.homeManagerModules.default];
            programs.caelestia = {
                enable = true;
                package = pkgs.caelestia-shell;
                settings = {
                    general = {
                        apps = let
                            inherit (config.modules.desktop) defaultPrograms;
                        in {
                            inherit (defaultPrograms) terminal;
                            playback = defaultPrograms.videoPlayer;
                            explorer = defaultPrograms.fileManager;
                        };
                        idle.timeouts = []; # disable idle
                    };
                    background = {
                        enabled = true;
                        desktopClock.enabled = true;
                        visualiser.enabled = false;
                    };
                    bar = {
                        entries = map (id: {
                            inherit id;
                            enabled = true;
                        }) [
                            "workspaces"
                            "spacer"
                            "tray"
                            "clock"
                            "statusIcons"
                        ];
                        status = {
                            inherit (cfg.shell) showNetwork showAudio;
                            showKbLayout = false;
                            showLockStatus = false;
                            showBluetooth = config.hardware.bluetooth.enable;
                            showBattery = with config.services; (upower.enable && power-profiles-daemon.enable);
                        };
                    };
                    launcher = {
                        vimKeybinds = true;
                        enableDangerousActions = true;
                        hiddenApps = [
                            "kvantummanager"
                            "fish"
                            "qt5ct"
                            "qt6ct"
                            "uuctl"
                            "Steam Linux Runtime 3.0 (sniper)"
                            "Proton 9.0"
                            "Proton EasyAntiCheat Runtime"
                            "Yazi"
                        ];
                    };
                    notifs.actionOnClick = true;
                    services.defaultPlayer = "YT Music";
                    session.vimKeybinds = true;
                };
                cli = {
                    enable = true;
                    package = pkgs.caelestia-cli;
                    settings.theme = {
                        enableGtk = false;
                        enableTerm = false;
                        enableBtop = false;
                    };
                };
            };
        };
    };
}
