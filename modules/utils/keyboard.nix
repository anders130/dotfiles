{lib, ...}: let
    inherit (lib) mkOption types;
in {
    options = {
        layout = mkOption {
            type = types.str;
            default = "us";
            description = "Keyboard layout";
        };
        variant = mkOption {
            type = types.str;
            default = "de_se_fi";
            description = "Keyboard variant";
        };
        options = mkOption {
            type = types.str;
            default = "caps:escape";
            description = "Keyboard options";
        };
    };

    config = cfg: {
        console.keyMap = cfg.layout;

        services.xserver.xkb = {
            inherit (cfg) layout variant options;
        };
    };
}
