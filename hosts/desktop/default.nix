{
    pkgs,
    username,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./disk-config.nix
    ];

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    bundles = {
        cli.enable = true;
        desktop = {
            enable = true;
            gaming.enable = true;
        };
    };

    modules = {
        applications.virt-manager.enable = true;
        hardware.amdgpu.enable = true;
    };

    boot.kernelParams = [
        "video=DP-3:1920x1080@60"
        "video=DP-1:3440x1440@144"
        "video=DP-2:1920x1080@144"
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    boot.kernelModules = ["sg"];

    environment.systemPackages = let
        libbluray = pkgs.libbluray.override {
            withAACS = true;
            withBDplus = true;
            withJava = true;
            libaacs = pkgs.libaacs;
            libbdplus = pkgs.libbdplus;
        };
        vlc = pkgs.vlc.override {
            inherit libbluray;
        };
    in [
        vlc
        pkgs.openjdk
    ];
    environment.variables.BDJ_LD_LIBRARY_PATH = "${pkgs.openjdk}/lib/server";
    # environment.systemPackages = with pkgs; [
    #     vlc
    #     libaacs
    #     libbdplus
    #     openjdk
    # ];

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

    services.printing.drivers = [ pkgs.hplip ];
}
