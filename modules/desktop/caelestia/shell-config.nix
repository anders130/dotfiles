{
    config,
    lib,
    ...
}: {
    options.shell.showNetwork = lib.mkEnableOption "Show network status";
    config = cfg: {
        hm.xdg.configFile."caelestia/shell.json".text = builtins.toJSON {
            general.apps.terminal = [config.modules.desktop.defaultPrograms.terminal];
            background = {
                enabled = true;
                desktopClock.enabled = true;
            };
            bar.status = {
                inherit (cfg.shell) showNetwork;
                showAudio = false;
                showAudioSwitcher = true;
                showKbLayout = false;
                showBluetooth = config.hardware.bluetooth.enable;
                showBattery = config.services.upower.enable;
            };
            launcher = {
                vimKeybinds = true;
                enableDangerousActions = true;
            };
            notifs.actionOnClick = true;
            session.vimKeybinds = true;
        };
    };
}
