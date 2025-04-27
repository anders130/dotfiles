{lib, ...}: {
    options = {
        layout = lib.mkOption {
            type = lib.types.str;
            default = "us";
            description = "Keyboard layout";
        };
        variant = lib.mkOption {
            type = lib.types.str;
            default = "de_se_fi";
            description = "Keyboard variant";
        };
    };

    config = cfg: {
        console.keyMap = cfg.layout;

        services.xserver.xkb = {
            layout = cfg.layout;
            variant = cfg.variant;
        };
    };
}
