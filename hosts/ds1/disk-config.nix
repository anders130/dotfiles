{
    disko.devices.disk.nixos = {
        type = "disk";
        device = "/dev/disk/by-id/put-your-disk-id-here";
        content = {
            type = "gpt";
            partitions = {
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
}
