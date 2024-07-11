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

    bundles.cli.enable = true;

    modules = {
        hardware.amdgpu.enable = true;
        virt-manager.enable = true;
    };

    boot.kernelParams = [
        "video=DP-3:1920x1080@60"
        "video=DP-1:3440x1440@144"
        "video=DP-2:1920x1080@144"
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    services.printing.drivers = [ pkgs.hplip ];
}
