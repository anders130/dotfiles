{
    den,
    dots,
    ...
}: {
    den.aspects.desktop = {
        includes =
            (with dots.desktop.provides; [
                mime
                autostart
                monitors
            ])
            ++ (with den.aspects; [
                theming

                audio
                printing

                bitwarden
                browser # personal search engines
                discord
                element
                qutebrowser
                signal
                youtube-music
            ]);

        nixos = {
            config,
            pkgs,
            ...
        }: {
            my.desktop.autostart = [
                {
                    command = "signal-desktop --start-in-tray";
                    afterKeyringUnlock = true;
                }
                {
                    delay = 1.0;
                    command = "noisetorch -i";
                }
                {
                    command = "vesktop --start-minimized";
                    afterKeyringUnlock = true;
                }
                {
                    command = "nextcloud --background";
                    afterKeyringUnlock = true;
                }
                {
                    command = "bitwarden";
                    afterKeyringUnlock = true;
                }
                {
                    command = "ssh-add-all-keys";
                    isApp = false;
                }
            ];
            my.nautilus.terminal = "kitty";

            environment.systemPackages = [
                (pkgs.writeShellScriptBin "autostart" ''
                    # hardware stuff
                    xrandr --output ${config.my.desktop.mainMonitor} --primary
                '')
            ];
        };
    };
}
