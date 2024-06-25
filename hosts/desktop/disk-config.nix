let
    mountOptions = [
        "users" # allows any user to mount and umount
        "nofail" # prevent system from failing if this drive doesn't mount
        "rw" # read-write
        "x-gvfs-show" # nautilus can see this drive
    ];
in {
    boot.supportedFilesystems = [
        "ext4"
        "btrfs"
        "exfat"
        "ntfs"
    ];

    fileSystems = {
        "/mnt/data" = {
            device = "/dev/disk/by-uuid/94beffa0-c53a-49d6-94e5-7be7092befb9";
            fsType = "btrfs";
            options = mountOptions;
        };

        "/mnt/games" = {
            device = "/dev/disk/by-uuid/33b4f5fb-1bdc-4f36-aa00-c5f04daeff67";
            fsType = "ext4";
            options = mountOptions ++ ["defaults" "exec"];
        };

        "/mnt/bigdata" = {
            device = "/dev/disk/by-uuid/EEFE-FA74";
            fsType = "exfat";
            options =
                mountOptions
                ++ [
                    "nodev"
                    "nosuid"
                    "uid=1000"
                    "gid=1000"
                ];
        };
    };

    disko.devices.disk = {
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
