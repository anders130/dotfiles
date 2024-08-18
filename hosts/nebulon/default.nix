{
    username,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];

    modules.services = {
        blocky.enable = true;
        minecraft.enable = true;
        plex.enable = true;
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    security.pam.sshAgentAuth.enable = true;

    hardware.enableRedistributableFirmware = true;

    # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
    # a different host. not used in this tutorial, but handy later.
    nix.settings.trusted-users = [username];

    services.openssh.enable = true;
}
