{
    # WM-agnostic autostart contract: the autostart list + firstLoginHook
    # options. WMs include dots.desktop.provides.default-programs and consume
    # them; the desktop layer sets them.
    dots.desktop.provides.default-programs = {
        nixos = {lib, ...}: let
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
        };

        homeManager = {lib, ...}: {
            options.my.desktop.firstLoginHook = lib.mkOption {
                type = lib.types.nullOr lib.types.package;
                default = null;
                description = "Script that exits 0 when the first login has completed";
            };
        };
    };

    # personal: xrandr autostart helper (uses my.desktop.mainMonitor)
    den.aspects.desktop.nixos = {
        config,
        pkgs,
        ...
    }: {
        environment.systemPackages = [
            (pkgs.writeShellScriptBin "autostart" ''
                # hardware stuff
                xrandr --output ${config.my.desktop.mainMonitor} --primary
            '')
        ];
    };
}
