{
    config,
    lib,
    pkgs,
    ...
}: lib.mkModule config ./amdgpu.nix {
    boot.initrd.kernelModules = ["amdgpu"];

    services.xserver.videoDrivers = ["amdgpu"];

    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
            vulkan-loader
            vulkan-validation-layers
            vulkan-extension-layer
        ];
    };
}
