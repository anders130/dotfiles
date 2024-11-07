{
    config,
    lib,
    ...
}: lib.mkModule config ./keyboard.nix {
    options = {
        layout = lib.mkOption {
            type = lib.types.str;
            default = "us";
            description = "Keyboard layout";
        };
        variant = lib.mkOption {
            type = lib.types.str;
            default = "";
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
