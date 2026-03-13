{inputs, ...}: {
    imports = [inputs.lumehub.nixosModules.default];

    modules = {
        bundles.rpi.enable = true;
        hardware.raspberry-pi = {
            enable = true;
            spi.enable = true;
        };
    };
    modules.programs.cli = {
        nvix.enable = false; # neovim config - probably huge
        nix-index.enable = false; # large database
        direnv.enable = false;
    };

    services.lumehub = {
        enable = true;
        openFirewall = true;
        settings = {
            led_controller.controller_type = "ws2801";
            led_controller.pixel_count = 256;
        };
        extraEffects.tv_mode = ''
            [[layers]]
            effect = "tv_effect"
            fade_start = 100.0
            fade_end   = 120.0
        '';
    };

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
