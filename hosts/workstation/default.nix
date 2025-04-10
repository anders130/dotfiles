{
    lib,
    pkgs,
    ...
}: {
    modules = {
        bundles = {
            dev.enable = true;
            desktop.enable = true;
        };
        desktop = {
            enable = true;
            mainMonitor = "eDP-1";
            gnome.enable = true;
            hyprland = {
                enable = true;
                extraConfig = ''
                    source = ./override.conf
                '';
            };
        };
        programs.gui = {
            nwg-displays.enable = true;
            zen-browser.enable = true;
        };
        hardware = {
            amdgpu.enable = true;
            displaylink.enable = true;
        };
    };

    hm.xdg.configFile."hypr/override.conf" = lib.mkSymlink ./hyprland.conf;

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
        kernelPackages = pkgs.linuxPackages_latest;
    };

    environment.systemPackages = with pkgs; [
        unstable.easyroam-connect-desktop
        logisim-evolution
    ];

    programs.nix-ld.enable = true;

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
