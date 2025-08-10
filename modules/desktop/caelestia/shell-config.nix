{config, ...}: {
    hm.xdg.configFile."caelestia/shell.json".text = builtins.toJSON {
        general.apps.terminal = [config.modules.desktop.defaultPrograms.terminal];
        background = {
            enabled = true;
            desktopClock.enabled = true;
        };
        bar.status = {
            showAudio = false;
            showAudioSwitcher = true;
            showKbLayout = false;
            showNetwork = false;
            showBluetooth = false;
            showBattery = false;
        };
        launcher = {
            vimKeybinds = true;
            enableDangerousActions = true;
        };
        notifs.actionOnClick = true;
        session.vimKeybinds = true;
    };
}
