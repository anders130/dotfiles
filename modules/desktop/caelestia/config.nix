{inputs, ...}: {
    dots.desktop.provides.caelestia.homeManager = {
        config,
        lib,
        pkgs,
        osConfig,
        ...
    }: let
        inherit (lib) mkOption types;
        secondaryMonitors = lib.filterAttrs (_: m: !m.isMain) osConfig.my.desktop.monitors;
    in {
        imports = [inputs.caelestia-shell.homeManagerModules.default];
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
        config.xdg.configFile = lib.mapAttrs' (name: _:
            lib.nameValuePair "caelestia/monitors/${name}/shell.json" {
                text = builtins.toJSON {lock.enabled = false;};
                force = true;
            })
        secondaryMonitors;
        config.programs.caelestia = {
            enable = true;
            package = pkgs.caelestia-shell;
            settings = {
                appearance.font.clock = "DejaVu Sans";
                general = {
                    apps = {
                        terminal = config.my.desktop.mime.terminal;
                        playback = config.my.desktop.mime.videoPlayer;
                        explorer = config.my.desktop.mime.fileManager;
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
                    statusIcons = let
                        inherit (config.my.caelestia.status) showNetwork showAudio showBluetooth showBattery;
                    in [
                        {
                            id = "lockStatus";
                            enabled = false;
                        }
                        {
                            id = "audio";
                            enabled = showAudio;
                        }
                        {
                            id = "microphone";
                            enabled = false;
                        }
                        {
                            id = "kbLayout";
                            enabled = false;
                        }
                        {
                            id = "network";
                            enabled = showNetwork;
                        }
                        {
                            id = "bluetooth";
                            enabled = showBluetooth;
                        }
                        {
                            id = "battery";
                            enabled = showBattery;
                        }
                    ];
                };
                launcher = {
                    inherit (config.my.desktop) hiddenApps;
                    vimKeybinds = true;
                    enableDangerousActions = true;
                };
                notifs.actionOnClick = true;
                services = {
                    defaultPlayer = "YT Music";
                    maxVolume = 1.5;
                };
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
