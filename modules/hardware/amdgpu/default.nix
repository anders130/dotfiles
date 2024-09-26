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

        services.xserver = {
            enable = true;
            videoDrivers = ["amdgpu"];
        };

        hardware.opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            extraPackages = with pkgs.unstable; [
                vulkan-loader
                vulkan-validation-layers
                vulkan-extension-layer
                amdvlk
            ];
            extraPackages32 = with pkgs.unstable; [
                driversi686Linux.amdvlk
            ];
            package = pkgs.unstable.mesa.drivers;
            package32 = pkgs.unstable.pkgsi686Linux.mesa.drivers;
        };

        environment.systemPackages = with pkgs; [
            unstable.mesa
            glxinfo
        ];
    };
}
