{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        modules.nvidia.enable = lib.mkEnableOption "nvidia";
    };

    config = lib.mkIf config.modules.nvidia.enable {
        services.xserver.videoDrivers = ["nvidia"];

        hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
                version = "555.42.02";
                sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
                sha256_aarch64 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
                openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
                settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
                persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
            };
            nvidiaPersistenced = true;
        };

        hardware.opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };

        environment.systemPackages = [
            (pkgs.writeScriptBin "set-fan-speed" ''${builtins.readFile ./set_fan_speed.sh}'')
        ];
    };
}
