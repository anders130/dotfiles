{
    hashedPassword,
    host,
    hostname,
    inputs,
    lib,
    pkgs,
    username,
    variables,
    ...
}: {
    imports = [
        ../../modules
        ./localization.nix
    ];

    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            permittedInsecurePackages = [];
        };
        overlays = [inputs.self.outputs.overlays.default];
    };
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.${username}.imports = [
            ./home.nix
        ];
    };

    # enable custom modules
    modules = {
        console = {
            fish.enable = lib.mkDefault true;
            git.enable = lib.mkDefault true;
        };
        services.docker.enable = lib.mkDefault true;
    };

    environment.variables = {
        NIX_FLAKE_DEFAULT_HOST = host.name;
        FLAKE = "/home/${username}/.dotfiles";
    };

    networking = {
        hostName = "${hostname}";
        networkmanager.enable = lib.mkDefault true;
    };

    services.openssh.enable = lib.mkDefault true;

    programs.ssh.startAgent = lib.mkDefault true;

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

    system.stateVersion = variables.version;
}
