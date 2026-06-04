{
    flake.modules.nixos.jesse-desktop = {pkgs, ...}: {
        boot = {
            binfmt.emulatedSystems = ["aarch64-linux"];
            loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
            };
            kernelPackages = pkgs.linuxPackages_latest;
            kernelParams = ["amdgpu.dcdebugmask=0x10"];
        };
        # slows down boot time
        systemd.services.NetworkManager-wait-online.enable = false;
    };
}
