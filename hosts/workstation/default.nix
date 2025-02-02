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
            desktop.enable = true;
        };
        desktop = {
            enable = true;
            mainMonitor = "eDP-1";
            gnome.enable = true;
            hyprland.enable = true;
        };
        programs.gui.zen-browser.enable = true;
        hardware = {
            amdgpu.enable = true;
            displaylink.enable = true;
        };
    };

    services = {
        tailscale.enable = true;
        xserver.displayManager.lightdm.enable = false;
        displayManager = {
            autoLogin.enable = false;
            defaultSession = "gnome";
        };
        fprintd.enable = true;
    };

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
        local.easyroam
        vivado
    ];

    programs.nix-ld.enable = true;
}
