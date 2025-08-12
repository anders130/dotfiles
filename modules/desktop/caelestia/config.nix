{
    config,
    lib,
    ...
}: {
    options.shell = {
        showNetwork = lib.mkEnableOption "Show network status";
        showAudioSwitcher = lib.mkEnableOption "Show audio switcher";
    };
    config = cfg: {
        hm.xdg.configFile = {
            "caelestia/shell.json".text = builtins.toJSON {
                general.apps.terminal = [config.modules.desktop.defaultPrograms.terminal];
                background = {
                    enabled = true;
                    desktopClock.enabled = true;
                };
                bar.status = {
                    inherit (cfg.shell) showNetwork showAudioSwitcher;
                    showAudio = false;
                    showKbLayout = false;
                    showBluetooth = config.hardware.bluetooth.enable;
                    showBattery = with config.services; (upower.enable && power-profiles-daemon.enable);
                };
                launcher = {
                    vimKeybinds = true;
                    enableDangerousActions = true;
                };
                notifs.actionOnClick = true;
                session.vimKeybinds = true;
            };
            "caelestia/cli.json".text = builtins.toJSON {
                theme = {
                    enableGtk = false;
                    enableTerm = false;
                    enableBtop = false;
                };
            };
        };
    };
}
