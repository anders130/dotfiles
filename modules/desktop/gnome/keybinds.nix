let
    mediaKeysPath = "org/gnome/settings-daemon/plugins/media-keys";

    mkCustomKeybindings = keybinds:
        builtins.genList
        (i: "/${mediaKeysPath}/custom-keybindings/custom${builtins.toString i}/")
        (builtins.length keybinds);

    mkDconfSettings = keybinds:
        builtins.listToAttrs (builtins.genList (i: {
            name = "${mediaKeysPath}/custom-keybindings/custom${toString i}";
            value = builtins.elemAt keybinds i;
        }) (builtins.length keybinds));

    keybinds = [
        {
            name = "open-terminal";
            binding = "<Super>Return";
            command = "kitty";
        }
        {
            name = "open-file-explorer";
            binding = "<Super>e";
            command = "nautilus";
        }
        {
            name = "open-browser";
            binding = "<Super>b";
            command = "firefox";
        }
    ];
in {
    config = cfg: {
        hm.dconf.settings = ((mkDconfSettings keybinds) // {
            "${mediaKeysPath}" = {
                custom-keybindings = mkCustomKeybindings keybinds;
                screensaver = ["<Super>BackSpace"];
            };

            "org/gnome/desktop/peripherals/keyboard" = {
                numlock-state = true;
                delay = "uint32 250";
                repeat-interval = "uint32 25";
            };

            "org/gnome/desktop/wm/keybindings" = {
                close = ["<Super>c"];
                toggle-fullscreen = ["<Super>f"];
                toggle-maximized = ["<Super>v"];
                move-to-workspace-1 = ["<Super><Shift>1"];
                move-to-workspace-2 = ["<Super><Shift>2"];
                move-to-workspace-3 = ["<Super><Shift>3"];
                move-to-workspace-4 = ["<Super><Shift>4"];
                move-to-workspace-5 = ["<Super><Shift>5"];
                move-to-workspace-6 = ["<Super><Shift>6"];
                move-to-workspace-7 = ["<Super><Shift>7"];
                move-to-workspace-8 = ["<Super><Shift>8"];
                move-to-workspace-9 = ["<Super><Shift>9"];

                switch-to-workspace-1 = ["<Super>1"];
                switch-to-workspace-2 = ["<Super>2"];
                switch-to-workspace-3 = ["<Super>3"];
                switch-to-workspace-4 = ["<Super>4"];
                switch-to-workspace-5 = ["<Super>5"];
                switch-to-workspace-6 = ["<Super>6"];
                switch-to-workspace-7 = ["<Super>7"];
                switch-to-workspace-8 = ["<Super>8"];
                switch-to-workspace-9 = ["<Super>9"];

                minimize = []; # unset Super+h
            };

            "org/gnome/shell/keybindings" = {
                switch-to-application-1 = [];
                switch-to-application-2 = [];
                switch-to-application-3 = [];
                switch-to-application-4 = [];
                switch-to-application-5 = [];
                switch-to-application-6 = [];
                switch-to-application-7 = [];
                switch-to-application-8 = [];
                switch-to-application-9 = [];
                toggle-message-tray = []; # this interfered with Super+v
            };

            "org/gnome/desktop/wm/preferences" = {
                mouse-button-modifier = "<Super>";
                num-workspaces = 9;
                resize-with-right-button = true;
                focus-mode = "mouse";
            };
        });
    };
}
