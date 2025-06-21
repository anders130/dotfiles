{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkOption types;
in {
    options.autostart = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of commands to execute on startup";
    };

    config = cfg: {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "autostart" ''
                # hardware stuff
                xrandr --output ${cfg.mainMonitor} --primary

                # apps
                ${lib.concatMapStringsSep "\n" (cmd: "uwsm app -- bash -c '${cmd}' &") cfg.autostart}
            '')
        ];
    };
}
