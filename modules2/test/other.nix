{
    config,
    lib,
    pkgs,
    ...
}: {
    options.other = lib.mkOption {
        type = lib.types.bool;
        default = true;
    };

    config = cfg: {
        services.pict-rs.enable = cfg.option;
    };
}
