{lib, ...}: {
    options.test = lib.mkOption {
        type = lib.types.attrsOf lib.types.int;
        default = {
            a = 1;
            b = 2;
        };
    };
}
