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
    ];

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    # enable custom modules
    modules.docker.enable = true;
    modules.fish.enable = true;
    modules.git.enable = true;

    environment.variables = {
        NIX_FLAKE_DEFAULT_HOST = host.name;
        FLAKE = "/home/${username}/.dotfiles";
    };

    networking.hostName = "${hostname}";

    services.openssh.enable = true;

    programs.ssh.startAgent = true;

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
        ];
    } // lib.optionalAttrs (hashedPassword != null) {
        hashedPassword = hashedPassword;
    };

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

    system.stateVersion = variables.version;
}
