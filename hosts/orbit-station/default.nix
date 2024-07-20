{
    pkgs,
    username,
    ...
}: {
    imports = [
        # ./hardware-configuration.nix
    ];

    modules.blocky.enable = true;

    boot = {
        kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
        loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
        };
    };

    security.pam.sshAgentAuth.enable = true;

    hardware.enableRedistributableFirmware = true;

    # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
    # a different host. not used in this tutorial, but handy later.
    nix.settings.trusted-users = [username];

    services.openssh.enable = true;
}
