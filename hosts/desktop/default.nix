{pkgs, ...}: {
    imports = [
        ./hardware-configuration.nix
        ./disk-config.nix
    ];

    hm.imports = [./home.nix];

    modules = {
        bundles = {
            dev.enable = true;
            desktop.enable = true;
            gaming.enable = true;
        };
        desktop = {
            enable = true;
            monitors = {
                DP-3 = {
                    resolution = "2560x1440";
                    refreshRate = 180;
                    position = "-2560x0";
                };
                DP-1 = {
                    isMain = true;
                    resolution = "3440x1440";
                    refreshRate = 144;
                    position = "0x0";
                };
                DP-2 = {
                    resolution = "2560x1440";
                    refreshRate = 180;
                    position = "3440x0";
                };
            };
            hyprland.enable = true;
            defaultPrograms.browser = "zen";
        };

        programs = {
            cli.nix.nix-daemon.enableLimit = true;
            gui = {
                virt-manager.enable = true;
                zen-browser.enable = true;
            };
        };
        hardware = {
            amdgpu.enable = true;
            bluetooth.enable = true;
        };
    };

    boot = {
        binfmt.emulatedSystems = ["aarch64-linux"];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
    };

    nix.settings.download-speed = 6250; # limit download speed to 50 Mbps

    environment.systemPackages = with pkgs; [
        jetbrains.rider
    ];
}
