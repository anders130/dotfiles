{inputs, ...}: {
    flake.modules.nixos.desktop = {...}: {
        imports = with inputs.self.modules.nixos; [
            bitwarden
            discord
            nautilus
            zen-browser
        ];
        home-manager.sharedModules = with inputs.self.modules.homeManager; [
            element
            kitty
            qutebrowser
            signal
            youtube-music
        ];
        my.desktop.autostart = [
            "signal-desktop --start-in-tray"
            {
                delay = 1.0;
                command = "noisetorch -i";
            }
            {
                delay = 3.0;
                command = "vesktop --start-minimized";
            }
            {
                command = "nextcloud --background";
                afterFirstLogin = true;
            }
            {
                command = "ssh-add-all-keys";
                isApp = false;
            }
        ];
    };
}
