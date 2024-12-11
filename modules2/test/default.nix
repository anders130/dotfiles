{
    config,
    lib,
    pkgs,
    ...
}: {
    options.option = lib.mkOption {
        type = lib.types.bool;
        default = true;
    };
    config = {
        services.nginx.enable = true;
    };
}
