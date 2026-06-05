{
    den.default.nixos = {
        config,
        lib,
        ...
    }: let
        inherit (lib) filterAttrs mkOption types;
    in {
        options.users.normalUsers = mkOption {
            type = types.listOf types.str;
            readOnly = true;
            default = builtins.attrNames (filterAttrs (_: u: u.isNormalUser) config.users.users);
        };
    };
}
