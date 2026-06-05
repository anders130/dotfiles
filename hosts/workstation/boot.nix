{inputs, ...}: {
    den.aspects.workstation.nixos = {
        lib,
        pkgs,
        ...
    }: {
        imports = [inputs.lanzaboote.nixosModules.lanzaboote];
        boot = {
            bootspec.enable = true;
            initrd.systemd.enable = true;
            loader.systemd-boot.enable = lib.mkForce false;
            lanzaboote = {
                enable = true;
                pkiBundle = "/etc/secureboot";

                settings = {
                    console-mode = "auto";
                    editor = false;
                };
            };
            kernelPackages = pkgs.linuxPackages_latest;
        };
        # slows down boot time
        systemd.services.NetworkManager-wait-online.enable = false;
    };
}
