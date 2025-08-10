{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkOption types;
in {
    options.autostart = mkOption {
        type = types.listOf (types.oneOf [
            types.str
            (types.submodule {
                options = {
                    command = mkOption {
                        type = types.str;
                    };
                    delay = mkOption {
                        type = types.float;
                        default = 0.0;
                        description = "Sleep for this many seconds before executing the command";
                    };
                    isApp = mkOption {
                        type = types.bool;
                        default = true;
                        description = "Whether the command should be executed with uwsm app";
                    };
                    afterFirstLogin = mkOption {
                        type = types.bool;
                        default = false;
                    };
                };
            })
        ]);
        default = [];
        description = "List of commands to execute on startup";
    };

    config = cfg: {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "autostart" ''
                # hardware stuff
                xrandr --output ${cfg.mainMonitor} --primary
            '')
        ];
    };
}
