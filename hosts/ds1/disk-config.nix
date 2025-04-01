let
    rackflixAddress = "192.168.2.2";
in {
    boot.supportedFilesystems = ["nfs"];

    fileSystems = {
        "/mnt/rackflix/data" = {
            device = "${rackflixAddress}:/Data";
            fsType = "nfs";
        };
        "/mnt/rackflix/appdata" = {
            device = "${rackflixAddress}:/appdata";
            fsType = "nfs";
        };
    };

    disko.devices.disk.nixos = {
        type = "disk";
        device = "/dev/nvme0n1";
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
