{
    hashedPassword,
    host,
    hostname,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    imports = [
        ./localization.nix
    ];

    # enable custom modules
    modules = {
        console = {
            fish.enable = lib.mkDefault true;
            git.enable = lib.mkDefault true;
            ssh.enable = lib.mkDefault true;
        };
        services.docker.enable = lib.mkDefault true;
        utils = {
            sops.enable = lib.mkDefault true;
            stylix.enable = lib.mkDefault true;
            home-manager.enable = lib.mkDefault true;
            keyboard.enable = lib.mkDefault true;
            nixpkgs.enable = lib.mkDefault true;
        };
    };

    environment.variables = {
        NIX_FLAKE_DEFAULT_HOST = host.name;
        FLAKE = "/home/${username}/.dotfiles";
    };

    networking = {
        firewall.enable = lib.mkDefault true;
        hostName = "${hostname}";
        networkmanager.enable = lib.mkDefault true;
    };

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "networkmanager"
        ];
    } // lib.optionalAttrs (hashedPassword != null) {
        hashedPassword = hashedPassword;
    };

    nix = {
        gc = {
            automatic = true;
            options = "--delete-older-than 7d";
        };

        package = pkgs.nixFlakes;

        registry = {
            custom.flake = inputs.self;
            nixpkgs.flake = inputs.nixpkgs;
            nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
        };

        settings = {
            accept-flake-config = true;
            auto-optimise-store = true;

            experimental-features = [
                "nix-command"
                "flakes"
            ];

            trusted-users = [username];
        };

        extraOptions = ''
            !include /home/${username}/.nix.conf
        '';
    };
}
