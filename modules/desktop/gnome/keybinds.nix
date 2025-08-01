{
    config,
    lib,
    ...
}: let
    inherit (builtins) genList length elemAt listToAttrs;
    mediaKeysPath = "org/gnome/settings-daemon/plugins/media-keys";
    num-workspaces = 9;

    mkIndexedAttrs = count: {nameFn, valueFn}:
        listToAttrs (genList (i: {
                name = nameFn i;
                value = valueFn i;
            })
            count);

    mkCustomKeybindingPaths = keybinds:
        genList (i: "/${mediaKeysPath}/custom-keybindings/custom${toString i}/")
        (length keybinds);

    mkCustomKeybindingEntries = keybinds:
        mkIndexedAttrs (length keybinds) {
            nameFn = i: "${mediaKeysPath}/custom-keybindings/custom${toString i}";
            valueFn = i: elemAt keybinds i;
        };

    mkBindings = prefix: modifier:
        mkIndexedAttrs num-workspaces {
            nameFn = i: "${prefix}-${toString (i + 1)}";
            valueFn = i: ["${modifier}${toString (i + 1)}"];
        };

    mkEmptyBindings = prefix: mkIndexedAttrs num-workspaces {
        nameFn = i: "${prefix}-${toString (i + 1)}";
        valueFn = _: [];
    };

    keybinds = let
        inherit (config.modules.desktop) defaultPrograms;
    in [
        {
            name = "open-terminal";
            binding = "<Super>Return";
            command = defaultPrograms.terminal;
        }
        {
            name = "open-file-manager";
            binding = "<Super>e";
            command = defaultPrograms.fileManager;
        }
        {
            name = "open-browser";
            binding = "<Super>b";
            command = defaultPrograms.browser;
        }
    ];
in {
    hm.dconf.settings = mkCustomKeybindingEntries keybinds // {
        "${mediaKeysPath}" = {
            custom-keybindings = mkCustomKeybindingPaths keybinds;
            screensaver = ["<Super>BackSpace"];
        };

        "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
            delay = lib.hm.gvariant.mkUint32 250;
            repeat-interval = lib.hm.gvariant.mkUint32 25;
        };

        "org/gnome/desktop/wm/keybindings" =
            mkBindings "switch-to-workspace" "<Super>"
            // mkBindings "move-to-workspace" "<Super><Shift>"
            // {
                close = ["<Super>c"];
                toggle-fullscreen = ["<Super>f"];
                toggle-maximized = ["<Super>v"];
                minimize = []; # unset Super+h
            };

        "org/gnome/shell/keybindings" =
            mkEmptyBindings "switch-to-application"
            // {
                toggle-message-tray = []; # interferes with Super+v
            };

        "org/gnome/desktop/wm/preferences" = {
            inherit num-workspaces;
            mouse-button-modifier = "<Super>";
            resize-with-right-button = true;
            focus-mode = "mouse";
        };
    };
}
