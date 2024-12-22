{
    lib,
    pkgs,
    ...
}: {
    options.autostart = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of commands to execute on startup";
    };

    config = cfg: {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "autostart" ''
                # hardware stuff
                xrandr --output ${cfg.mainMonitor} --primary

                # apps
                ${lib.concatMapStringsSep "\n" (cmd: "${cmd} &") cfg.autostart}
            '')
        ];
    };
}
