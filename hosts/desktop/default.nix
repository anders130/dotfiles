{
    pkgs,
    config,
    ...
}: let
    mountOptions = [
        "users" "nofail" "x-gvfs-show" "rw" "uid=1000"
    ];
in {
    imports = [
        ./hardware-configuration.nix
    ];
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

        package = let 
            rcu_patch = pkgs.fetchpatch {
                url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
                hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
            };
        in config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "535.154.05";
            sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
            sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
            openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
            settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
            persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

            patches = [ rcu_patch ];
        };
    }; 
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
}
