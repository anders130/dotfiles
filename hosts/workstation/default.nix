{
    lib,
    pkgs,
    ...
}: {
    imports = [
        ./disk-config.nix
        ./hardware-configuration.nix
    ];

    hm.imports = [./home.nix];

    modules = {
        bundles = {
            dev.enable = true;
            desktop = {
                enable = true;
                mainMonitor = "eDP-1";
            };
        };

        programs.gui.zen-browser.enable = true;

        gnome.enable = true;
        hardware = {
            amdgpu.enable = true;
            displaylink.enable = true;
        };
        hypr.displayManager = {
            enable = false;
            autoLogin.enable = false;
        };
    };

    services.tailscale.enable = true;

    boot = {
        bootspec.enable = true;

        initrd.systemd.enable = true;
        loader.systemd-boot.enable = lib.mkForce false;

        lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";

            settings = {
                console-mode = "auto";
                editor = false;
            };
        };
    };

    environment.systemPackages = with pkgs; [
        xwaylandvideobridge # could be helpful for some things
        local.easyroam
        local.keil-uvision
        vivado
    ];

    services.displayManager.defaultSession = "gnome";
    programs.nix-ld.enable = true;
}
