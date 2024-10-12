{
    config,
    lib,
    ...
}: let
    cfg = config.modules.hardware.keyboard;
in {
    options.modules.hardware.keyboard = {
        enable = lib.mkEnableOption "Enable keyboard";
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

    config = lib.mkIf cfg.enable {
        console.keyMap = cfg.layout;

        services.xserver.xkb = {
            layout = cfg.layout;
            variant = cfg.variant;
        };
    };
}
