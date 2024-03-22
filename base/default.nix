{
    username,
    hostname,
    pkgs,
    inputs,
    ...
}: {
    imports = [
        ../fish
        ../tmux

        ./packages.nix
        ./localization.nix
    ];

    networking.hostName = "${hostname}";

    # SSH
    services.openssh.enable = true;

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "docker"
        ];
    };
    
    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    system.stateVersion = "23.11";

    virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
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

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;
}
