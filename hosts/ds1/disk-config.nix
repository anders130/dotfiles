{lib, ...}: let
    rackflixAddress = "192.168.2.2";
    mkNfsMount = folder: {
        type = "nfs";
        mountConfig.Options = "noatime";
        what = "${rackflixAddress}:${folder}";
        where = "/mnt/rackflix/${lib.toLower folder}";
    };
    mkNfsAutomount = folder: {
        wantedBy = ["multi-user.target"];
        automountConfig.TimeoutIdleSec = "600";
        where = "/mnt/rackflix/${lib.toLower folder}";
    };
    sharedFolders = ["Data" "appdata"];
in {
    boot.supportedFilesystems = ["nfs"];

    systemd.mounts = map mkNfsMount sharedFolders;
    systemd.automounts = map mkNfsAutomount sharedFolders;

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
