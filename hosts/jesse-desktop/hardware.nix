{inputs, ...}: {
    flake.modules.nixos.jesse-desktop = {
        config,
        lib,
        ...
    }: {
        boot = {
            initrd.availableKernelModules = [
                "ahci"
                "nvme"
                "sd_mod"
                "sr_mod"
                "usb_storage"
                "usbhid"
                "xhci_pci"
            ];
            kernelModules = ["kvm-amd"];
        };

        networking.useDHCP = lib.mkDefault true;
        hardware.enableRedistributableFirmware = lib.mkDefault true;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        imports = [inputs.self.modules.nixos.amdgpu];
        home-manager.sharedModules = [{my.btop.rocmSupport = true;}];
    };
}
