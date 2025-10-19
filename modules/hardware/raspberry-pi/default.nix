{lib, ...}: {
    options.spi.enable = lib.mkEnableOption "Enable SPI";
    config = cfg: {
        hardware.raspberry-pi.config.all.base-dt-params.spi = lib.mkIf cfg.spi.enable {
            enable = true;
            value = "on";
        };
    };
}
