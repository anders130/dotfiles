{
    config,
    lib,
    pkgs,
    ...
}: {
    options.modules.kanata = {
        enable = lib.mkEnableOption "kanata";
    };

    config = lib.mkIf config.modules.kanata.enable {
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
