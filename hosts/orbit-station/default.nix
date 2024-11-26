{pkgs, ...}: {
    imports = [
        ./hardware-configuration.nix
    ];

    modules = {
        bundles.rpi.enable = true;
        services.blocky.enable = true;
    };

    boot = {
        kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
        loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
        };
    };
}
