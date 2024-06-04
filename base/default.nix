{
    username,
    hostname,
    hashedPassword,
    host,
    variables,
    pkgs,
    lib,
    inputs,
    ...
}: {
    imports = [
        ../fish
        ../tmux

        ./packages.nix
        ./localization.nix
    ];

    networking = {
        hostName = "${hostname}";
        networkmanager.enable = lib.mkDefault true;
    };

    # SSH
    services.openssh.enable = true;

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "docker"
            "networkmanager"
        ];
    } // lib.optionalAttrs (hashedPassword != null) {
        hashedPassword = hashedPassword;
    };

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    system.stateVersion = variables.version;
    environment.variables.NIX_FLAKE_DEFAULT_HOST = host.name;

    nix = {
        settings = {
            trusted-users = [username];

            accept-flake-config = true;
            auto-optimise-store = true;
        };

        registry.nixpkgs.flake = inputs.nixpkgs;

        package = pkgs.nixFlakes;
        extraOptions = ''experimental-features = nix-command flakes'';

        gc = {
            automatic = true;
            options = "--delete-older-than 7d";
        };
    };

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;
}
