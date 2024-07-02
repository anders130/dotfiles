{
    username,
    ...
}: {
    imports = [
        ./packages.nix
        ./gaming.nix
        ./defaultApplications.nix
        ../../../hypr
        ../../../ags
        ../../../alacritty
    ];

    modules = {
        anki.enable = true;
        discord.enable = true;
        firefox.enable = true;
        plymouth.enable = true;
        rofi.enable = true;
        stylix = {
            enable = true;
            desktop.enable = true;
        };
    };

    # make system bootable
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking.firewall.enable = true;

    services.xserver = {
        enable = true;

        # keyboard layout
        xkb = {
            layout = "de";
            variant = "";
        };
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;
    # Enable printer autodiscovery
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    location.provider = "geoclue2";
    services.gnome.tracker-miners.enable = true;

    # needed for trash to work in nautilus
    services.gvfs.enable = true;
}
