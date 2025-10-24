{
    config,
    lib,
    ...
}: {
    options.spi.enable = lib.mkEnableOption "Enable SPI";
    config = cfg: {
        hardware =
            # this is a hack to make sure hosts don't break that don't have those options
            if !(config.hardware ? raspberry-pi)
            then {}
            else {
                raspberry-pi.config.all.base-dt-params.spi = lib.mkIf cfg.spi.enable {
                    enable = true;
                    value = "on";
                };
            };
    };
}
