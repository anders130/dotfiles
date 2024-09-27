{
    lib,
    pkgs,
    username,
    ...
}: {
    imports = [
        ./disk-config.nix
        ./hardware-configuration.nix
    ];

    home-manager.users.${username}.imports = [
        ./home.nix
    ];

    bundles = {
        cli.enable = true;
        desktop = {
            enable = true;
            mainMonitor = "eDP-1";
        };
    };

    modules.hardware = {
        amdgpu.enable = true;
        displaylink.enable = true;
    };

    services.tailscale.enable = true;

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
    };

    environment.systemPackages = with pkgs; [
        xwaylandvideobridge # could be helpful for some things
    ];
}
