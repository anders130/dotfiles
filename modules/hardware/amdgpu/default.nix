{
    config,
    lib,
    ...
}: {
    options = {
        modules.hardware.amdgpu.enable = lib.mkEnableOption "amdgpu";
    };

    config = lib.mkIf config.modules.hardware.amdgpu.enable {
        boot.initrd.kernelModules = ["amdgpu"];

        services.xserver = {
            enable = true;
            videoDrivers = ["amdgpu"];
        };

        hardware.opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };
    };
}
