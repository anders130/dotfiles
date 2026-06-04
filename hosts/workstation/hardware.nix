{
    flake.modules.nixos.workstation = {
        config,
        lib,
        ...
    }: {
        boot = {
            initrd.availableKernelModules = [
                "nvme"
                "sd_mod"
                "thunderbolt"
                "usb_storage"
                "xhci_pci"
            ];
            kernelModules = ["kvm-amd"];
        };

        networking.useDHCP = lib.mkDefault true;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
