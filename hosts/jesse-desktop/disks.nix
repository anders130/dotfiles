{den, ...}: {
    den.aspects.jesse-desktop = {
        includes = [den.aspects.disko];
        nixos.disko.devices.disk = {
            nixos = {
                type = "disk";
                device = "/dev/disk/by-id/nvme-eui.0025385811b170f2";
                content = {
                    type = "gpt";
                    partitions = {
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
                    partitions.root = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "btrfs";
                        };
                    };
                };
            };
            games = {
                type = "disk";
                device = "/dev/disk/by-id/nvme-CT2000P3SSD8_2247E68A613E";
                content = {
                    type = "gpt";
                    partitions.root = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                        };
                    };
                };
            };
        };
    };
}
