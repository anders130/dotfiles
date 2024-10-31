{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        modules.hardware.amdgpu.enable = lib.mkEnableOption "amdgpu";
    };

    config = lib.mkIf config.modules.hardware.amdgpu.enable {
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
    };
}
