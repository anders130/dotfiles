{
    username,
    pkgs,
    ...
}: {
    imports = [
        ./packages.nix
        ../../hyprland
        ../../rofi
        ../../ags
        ../../alacritty
    ];

    # make system bootable
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    
    services.xserver = {
        enable = true;
        displayManager.gdm = {
            enable = true;
            wayland = true;
        };

        # keyboard layout
        layout = "de";
        xkbVariant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

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

    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [
            "CascadiaCode"
        ]; })
    ];
    
    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    # use gtk desktop portal
    # (recommended for usage alongside hyprland desktop portal)
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
}
