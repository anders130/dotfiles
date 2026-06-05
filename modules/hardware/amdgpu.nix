{
    den.aspects.amdgpu.nixos = {lib, ...}: {
        hardware.graphics = {
            enable = lib.mkDefault true;
            enable32Bit = lib.mkDefault true;
        };
        hardware.amdgpu.initrd.enable = lib.mkDefault true;
    };
}
