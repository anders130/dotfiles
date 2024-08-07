{
    config,
    lib,
    username,
    ...
}: {
    imports = [
        ./gaming.nix
        ./packages.nix
    ];

    options.bundles.desktop = {
        enable = lib.mkEnableOption "Enable desktop bundle";
        gaming.enable = lib.mkEnableOption "Enable gaming stuff";
    };

    config = lib.mkIf config.bundles.desktop.enable {
        modules = {
            ags.enable = lib.mkDefault true;
            applications = {
                alacritty.enable = lib.mkDefault true;
                anki.enable = lib.mkDefault true;
                discord.enable = lib.mkDefault true;
                firefox.enable = lib.mkDefault true;
                kitty.enable = lib.mkDefault true;
                nautilus = {
                    enable = lib.mkDefault true;
                    terminal = lib.mkDefault "kitty";
                };
                rofi.enable = lib.mkDefault true;
            };
            hardware.kanata.enable = lib.mkDefault true;
            hypr.enable = lib.mkDefault true;
            theming = {
                plymouth.enable = lib.mkDefault true;
                stylix = {
                    enable = lib.mkDefault true;
                    desktop.enable = lib.mkDefault true;
                };
            };
        };

        # make system bootable
        boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        networking.firewall.enable = lib.mkDefault true;

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
            gtk.enable = true;
        };


        xdg.mime.defaultApplications = {
            "application/pdf" = "firefox.desktop";
            "image/*" = "loupe.desktop";
            "video/*" = "totem.desktop";
            "audio/*" = "gnome-music.desktop";
            "text/*" = "neovim.desktop";
        };

        location.provider = "geoclue2";
        services.gnome.tracker-miners.enable = true;
    };
}
