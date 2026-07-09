{den, ...}: {
    den.aspects.jesse-desktop = {
        includes = [den.aspects.disko];
        nixos.disko.devices.disk = {
            nixos = {
                type = "disk";
                device = "/dev/disk/by-id/nvme-eui.002538a36141b41e";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            type = "EF00";
                            size = "2G";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                            };
                        };
                        swap = {
                            size = "64G";
                            content = {
                                type = "swap";
                                resumeDevice = true;
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
                device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NX0R849941A";
                content = {
                    type = "gpt";
                    partitions.data = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            extraArgs = ["-L" "Data"];
                            mountpoint = "/mnt/data";
                            mountOptions = ["defaults" "nofail" "x-gvfs-show"];
                        };
                    };
                };
            };
        };
    };
}
