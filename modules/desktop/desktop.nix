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

        nixos = {
            config,
            pkgs,
            ...
        }: {
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
