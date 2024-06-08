{
    config,
    lib,
    ...
}: let
    mountOptions = [
        "users" "nofail" "x-gvfs-show" "rw" "uid=1000"
    ];
in {
    imports = [
        ./hardware-configuration.nix
    ];

    modules.virt-manager.enable = true;

    boot.supportedFilesystems = [ "ntfs" "exfat" ];

    fileSystems = {
        "/mnt/b" = {
            device = "/dev/disk/by-uuid/72047C9F047C67CD";
            fsType = "ntfs";
            options = mountOptions;
        };
        "/mnt/windows" = {
            device = "/dev/disk/by-uuid/12B00FF0B00FD8DD";
            fsType = "ntfs";
            options = mountOptions;
        };
        "/mnt/games" = {
            device = "/dev/disk/by-uuid/5ABC15A6BC157E27";
            fsType = "ntfs";
            options = mountOptions;
        };
        "/mnt/videos" = {
            device = "/dev/disk/by-uuid/301E74F51E74B606";
            fsType = "ntfs";
            options = mountOptions;
        };
        "/mnt/data" = {
            device = "/dev/disk/by-uuid/8EEC21A8EC218C11";
            fsType = "ntfs";
            options = mountOptions;
        };
    };

    # Nvidia gpu
    services.xserver.videoDrivers = [ "nvidia" ];
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
            persistencedSha256 = lib.fakeSha256;
        };
    };
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
