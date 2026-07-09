{
    den.aspects.jesse-desktop.nixos = {
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
        in {
            "/mnt/games" = {
                device = "/dev/disk/by-uuid/33b4f5fb-1bdc-4f36-aa00-c5f04daeff67";
                fsType = "ext4";
                options = mountOptions ++ ["defaults" "exec"];
            };
        };
    };
}
