{
    disko.devices.disk = {
        nixos = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-eui.0025385811b170f2";
            content = {
                type = "gpt";
                partitions = {
                    # boot = {
                    #     size = "1M";
                    #     type = "EF02"; # for grub MBR
                    #     priority = 1; # Needs to be first partition
                    # };
                    # EFI System Partition
                    ESP = {
                        type = "EF00";
                        size = "512M";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                        };
                    };
                    root = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/";
                        };
                    };
                };
            };
        };

        data = {
            type = "disk";
            device = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_1000GB_210204448305";
            content = {
                type = "gpt";
                partitions.luks = {
                    size = "100%";
                    content = {
                        type = "luks";
                        name = "encrypted";
                        askPassword = true;
                        initrdUnlock = false;
                        settings.allowDiscards = true;
                        content = {
                            type = "btrfs";
                            extraArgs = [ "-f" ];
                        };
                    };
                };
            };
        };

        # games = {
        #     type = "disk";
        #     device = "/dev/disk/by-id/nvme-CT2000P3SSD8_2247E68A613E";
        # };
        #
        # videos = {
        #     type = "disk";
        #     device = "/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT3K27G";
        # };
        #
        # data2 = {
        #     type = "disk";
        #     device = "/dev/disk/by-id/ata-ST1000DM010-2EP102_Z9AB2VLZ";
        # };
    };
}
