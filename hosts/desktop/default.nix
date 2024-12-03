{
    pkgs,
    username,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./disk-config.nix
        ./monitors.nix
    ];

    home-manager.users.${username}.imports = [./home.nix];

    modules = {
        bundles = {
            dev.enable = true;
            desktop = {
                enable = true;
                gaming.enable = true;
            };
        };

        programs.gui = {
            virt-manager.enable = true;
            zen-browser.enable = true;
        };
        hypr.browser = "zen";
        hardware.amdgpu.enable = true;
    };

    boot = {
        binfmt.emulatedSystems = ["aarch64-linux"];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
    };

    systemd = {
        slices."nix-daemon".sliceConfig = {
            ManagedOOMMemoryPressure = "kill";
            ManagedOOMMemoryPressureLimit = "50%";
        };
        services."nix-daemon".serviceConfig = {
            Slice = "nix-daemon.slice";
            OOMScoreAdjust = 1000;
        };
    };

    nix.settings.download-speed = 6250; # limit download speed to 50 Mbps
}
