{
    lib,
    modulesPath,
    ...
}: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot = {
        initrd.availableKernelModules = ["xhci_pci" "usbhid"];
        initrd.kernelModules = [];
        kernelModules = [];
        extraModulePackages = [];
    };

    fileSystems."/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = ["noatime"];
    };

    swapDevices = [];
    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
