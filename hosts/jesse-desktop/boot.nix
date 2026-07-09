{
    den.aspects.jesse-desktop.nixos = {pkgs, ...}: {
        boot = {
            binfmt.emulatedSystems = ["aarch64-linux"];
            loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
            };
            kernelPackages = pkgs.linuxPackages_latest;
            kernelParams = [
                "amdgpu.dcdebugmask=0x10"
                "amd_pstate=active" # proper CPPC power management for Zen 5 (9950X3D)
            ];
        };
        # slows down boot time
        systemd.services.NetworkManager-wait-online.enable = false;
    };
}
