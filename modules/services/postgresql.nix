{lib, ...}: let
    inherit (builtins) attrNames;
    inherit (lib) mapAttrsToList mkOption types;
in {
    options.databases = mkOption {
        type = types.attrsOf (types.submodule {
            options.superuser = mkOption {
                type = types.bool;
                default = false;
            };
        });
        default = {};
        description = "PostgreSQL databases to create";
    };
    config = cfg: {
        services.postgresql = {
            enable = true;
            ensureDatabases = attrNames cfg.databases;
            ensureUsers =
                cfg.databases
                |> mapAttrsToList (name: value: {
                    inherit name;
                    ensureDBOwnership = true;
                    ensureClauses = {
                        inherit (value) superuser;
                    };
                });
        };
    };
}
