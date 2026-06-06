{
    den,
    dots,
    ...
}: {
    den.aspects.desktop = {
        includes =
            [dots.desktop.provides.default-programs]
            ++ (with den.aspects; [
                bitwarden
                discord
                nautilus
                zen-browser
                element
                kitty
                nvix
                qutebrowser
                signal
                youtube-music
            ]);
        nixos.my.desktop.autostart = [
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
        nixos.my.nautilus.terminal = "kitty";
    };
}
