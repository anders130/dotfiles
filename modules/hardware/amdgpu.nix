{
    config,
    lib,
    ...
}:
lib.mkModule config ./amdgpu.nix {
    hardware.graphics = {
        enable = lib.mkDefault true;
        enable32Bit = lib.mkDefault true;
    };

    hardware.amdgpu.initrd.enable = lib.mkDefault true;
}
