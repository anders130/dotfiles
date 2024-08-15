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

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    # enable custom modules
    modules = {
        console = {
            fish.enable = true;
            git.enable = true;
        };
        services.docker.enable = true;
    };

    environment.variables = {
        NIX_FLAKE_DEFAULT_HOST = host.name;
        FLAKE = "/home/${username}/.dotfiles";
    };

    networking = {
        hostName = "${hostname}";
        networkmanager.enable = lib.mkDefault true;
    };

    services.openssh.enable = true;

    programs.ssh.startAgent = true;

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

        registry.nixpkgs.flake = inputs.nixpkgs;

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
