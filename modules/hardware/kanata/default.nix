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
                    caps
                )
                (deflayer default
                    esc
                )
            '';
        };
    };
}
