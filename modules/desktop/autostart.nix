{
    dots.desktop.provides.autostart = {
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
                            afterKeyringUnlock = mkOption {
                                type = types.bool;
                                default = false;
                                description = "Wait until the login keyring is unlocked before executing";
                            };
                        };
                    })
                ]);
                default = [];
                description = "List of commands to execute on startup";
            };
        };
    };
}
