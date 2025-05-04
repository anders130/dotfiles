{pkgs, ...}: {
    modules = {
        bundles.rpi.enable = true;
        services.plexamp = {
            enable = true;
            claimToken = "claim-ZfsyVbAaBnx7Dmspq2Lf";
            playerName = "nix-pi";
        };
    };

    console.enable = false;
    environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
    ];

    boot = {
        kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
        loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
        };
    };

    system.stateVersion = "24.11";
    hm.home.stateVersion = "24.11";
}
