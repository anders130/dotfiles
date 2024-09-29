{
    config,
    lib,
    username,
    ...
}: let
    cfg = config.modules.gnome;
    mediaKeysPath = "org/gnome/settings-daemon/plugins/media-keys";

    mkKeybind = {
        name,
        binding,
        command,
    }: {inherit name binding command;};

    keybinds = [
        (mkKeybind {
            name = "open-terminal";
            binding = "<Super>Return";
            command = "kitty";
        })
        (mkKeybind {
            name = "open-file-explorer";
            binding = "<Super>e";
            command = "nautilus";
        })
    ];

    customKeybindings =
        builtins.genList
        (i: "/${mediaKeysPath}/custom-keybindings/custom${builtins.toString i}/")
        (builtins.length keybinds);

    customKeybindingsDconfSettings = builtins.listToAttrs (builtins.genList (i: {
        name = "${mediaKeysPath}/custom-keybindings/custom${toString i}";
        value = builtins.elemAt keybinds i;
    }) (builtins.length keybinds));
in {
    config.home-manager.users.${username}.dconf.settings =
        lib.mkIf cfg.enable ({
            "${mediaKeysPath}".custom-keybindings = customKeybindings;
        }
        // customKeybindingsDconfSettings);
}
