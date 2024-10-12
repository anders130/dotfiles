{
    config,
    lib,
    pkgs,
    ...
}: {
    options.modules.hardware.kanata = {
        enable = lib.mkEnableOption "kanata";
    };

    config = lib.mkIf config.modules.hardware.kanata.enable {
        services.kanata = {
            enable = true;
            package = pkgs.kanata;
            keyboards.default.config = ''
                (defsrc
                    caps z y
                )
                (deflayer default
                    esc y z
                )
            '';
            # reset glove80 configuration
            keyboards.glove80 = {
                devices = ["/dev/input/by-id/usb-MoErgo_Glove80_Left_moergo.com:GLV80-BD7B4D3B999EE829-event-kbd"];
                config = ''
                    (defsrc)
                    (deflayer default)
                '';
            };
        };
    };
}
