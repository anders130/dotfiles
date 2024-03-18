{
    secrets,
    username,
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        firefox
        bitwarden
    ];

    stable-packages = with pkgs; [
        git-credential-manager
    ];
in {
    imports = [
        ./hardware-configuration.nix
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
        desktopManager.gnome.enable = true;
        # keyboard layout
        layout = "de";
        xkbVariant = "";
    };

    # console keyboard layout
    console.keyMap = "de";

    # Select internationalisation properties.
    i18n.defaultLocale = "de_DE.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
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


    environment.systemPackages = 
        stable-packages
        ++ unstable-packages;

    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [
            "FiraMono"
        ]; })
    ];

    # environment.sessionVariables = {
    #     GCM_CREDENTIAL_STORE = "secretservice";
    # };
    # home-manager.users.${username} = { config, ... }: {
    #     home.file.".gitconfig".text = ''
    #     [user]
    #         name = ${secrets.git_credentials.username}
    #         email = ${secrets.git_credentials.email}
    #     [init]
    #         defaultBranch = master
    #     [credentials]
    #         credentialStore = secretservice
    #         helper = ${pkgs.git-credential-manager}/bin/git-credential-manager
    # '';
    # };
}
