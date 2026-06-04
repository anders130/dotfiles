{
    flake.modules.nixos.desktop = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) mkOption types;
    in {
        options.my.desktop.autostart = mkOption {
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
        config = {
            environment.systemPackages = [
                (pkgs.writeShellScriptBin "autostart" ''
                    # hardware stuff
                    xrandr --output ${config.my.desktop.mainMonitor} --primary
                '')
            ];
            home-manager.sharedModules = [
                {
                    my.desktop.autostart = config.my.desktop.autostart;
                }
            ];
        };
    };

    flake.modules.homeManager.desktop = {lib, ...}: let
        inherit (lib) mkOption types;
    in {
        options.my.desktop = {
            autostart = mkOption {
                type = types.listOf types.anything;
                default = [];
            };
            firstLoginHook = mkOption {
                type = types.nullOr types.package;
                default = null;
                description = "Script that exits 0 when the first login has completed";
            };
        };
    };
}
