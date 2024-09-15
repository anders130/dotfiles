{pkgs, ...}: {
    imports = [
        ./hardware-configuration.nix
    ];

    bundles.rpi.enable = true;

    modules.services.blocky.enable = true;

    boot = {
        kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
        loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
        };
    };
}
