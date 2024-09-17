{
    disko.devices.disk.nixos = {
        type = "disk";
        device = "/dev/sda";
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
                luks = {
                    size = "100%";
                    content = {
                        type = "luks";
                        name = "encrypted-root";
                        askPassword = true; # set password when running disko
                        settings.allowDiscards = true; # recommended for SSDs
                        content = {
                            type = "btrfs";
                            extraArgs = ["-f"]; # force overwrite of existing key
                            subvolumes = {
                                "/main" = {
                                    mountpoint = "/";
                                    swap.".swaptfile".size = "8G";
                                };
                                "/home" = {
                                    mountpoint = "/home";
                                };
                                "/nix" = {
                                    mountpoint = "/nix";
                                    mountOptions = ["noatime"]; # don't save latest access time
                                };
                            };
                        };
                    };
                };
            };
        };
    };
}
