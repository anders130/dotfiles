{
    flake.modules.nixos.jesse-desktop = {lib, ...}: let
        username = "jesse";
    in {
        boot.supportedFilesystems = [
            "ext4"
            "btrfs"
            "exfat"
            "ntfs"
        ];
        fileSystems = let
            mountOptions = [
                "users" # allows any user to mount and umount
                "nofail" # prevent system from failing if this drive doesn't mount
                "rw" # read-write
                "x-gvfs-show" # nautilus can see this drive
            ];
            bindMount = drive: name: {
                name = "/home/${username}/${name}";
                value = {
                    device = "${drive}/${name}";
                    fsType = "none";
                    options = [
                        "bind"
                        "x-gvfs-hide"
                    ];
                };
            };
        in
            lib.mkMerge [
                {
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
                }
                (builtins.listToAttrs (map (bindMount "/mnt/data") [
                    "Documents"
                    "Downloads"
                    "Music"
                    "Pictures"
                    "Videos"
                ]))
            ];
    };
}
