{lib, ...}: {
    options.other = lib.mkOption {
        type = lib.types.int;
        default = 1;
    };
}
