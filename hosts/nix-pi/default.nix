{
    bundles.rpi.enable = true;

    raspberry-pi-nix.board = "bcm2711";

    hardware = {
        bluetooth.enable = true;
        raspberry-pi = {
            config = {
                all = {
                    base-dt-params = {
                        # enable autoprobing of bluetooth driver
                        # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
                        krnbt = {
                            enable = true;
                            value = "on";
                        };
                    };
                };
            };
        };
    };
}
