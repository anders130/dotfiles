{lib, ...}: let
    rackflixAddress = "192.168.2.2";
in {
    fileSystems =
        ["Data" "appdata"]
        |> map (folder: {
            name = "/mnt/rackflix/${lib.toLower folder}";
            value = {
                device = "${rackflixAddress}:${folder}";
                fsType = "nfs";
                options = [
                    "nfsvers=4.1" # latest version supported by QNAP
                    "rsize=1048576" # max supported read size for NFSv4 (1 MiB)
                    "wsize=1048576" # max write size
                    "noatime"
                    "hard"
                    "timeo=600"
                    "retrans=2"
                    "noauto" # prevent mounting on boot
                    "x-systemd.automount" # lazy mounting
                    "x-systemd.idle-timeout=600" # auto-unmount after 600 seconds of inactivity
                ];
            };
        })
        |> builtins.listToAttrs;

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
