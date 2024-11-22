{
    pkgs,
    username,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./disk-config.nix
    ];

    home-manager.users.${username}.imports = [
        ./home.nix
    ];

    bundles = {
        cli.enable = true;
        desktop = {
            enable = true;
            gaming.enable = true;
        };
    };

    modules = {
        applications = {
            virt-manager.enable = true;
            zen-browser.enable = true;
        };
        hardware.amdgpu.enable = true;
    };

    boot = {
        binfmt.emulatedSystems = ["aarch64-linux"];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [
            "video=DP-3:1920x1080@60"
            "video=DP-1:3440x1440@144"
            "video=DP-2:1920x1080@144"
        ];
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
