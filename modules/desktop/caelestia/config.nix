{inputs, ...}: {
    flake.modules.homeManager.caelestia = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) mkOption types;
    in {
        options.my.caelestia = {
            status = {
                showNetwork = mkOption {
                    type = types.bool;
                    default = false;
                };
                showAudio = mkOption {
                    type = types.bool;
                    default = false;
                };
                showBluetooth = mkOption {
                    type = types.bool;
                    default = false;
                };
                showBattery = mkOption {
                    type = types.bool;
                    default = false;
                };
            };
        };
        imports = [inputs.caelestia-shell.homeManagerModules.default];
        config.programs.caelestia = {
            enable = true;
            package = pkgs.caelestia-shell;
            settings = {
                appearance.font.family.clock = "DejaVu Sans";
                general = {
                    apps = {
                        terminal = config.my.desktop.defaultPrograms.terminal;
                        playback = config.my.desktop.defaultPrograms.videoPlayer;
                        explorer = config.my.desktop.defaultPrograms.fileManager;
                    };
                    idle.timeouts = []; # disable idle
                };
                background = {
                    enabled = true;
                    desktopClock = {
                        enabled = true;
                        scale = 0.7;
                    };
                    visualiser.enabled = false;
                };
                bar = {
                    clock.showIcon = false;
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
                        inherit (config.my.caelestia.status) showNetwork showAudio showBluetooth showBattery;
                        showKbLayout = false;
                        showLockStatus = false;
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
}
