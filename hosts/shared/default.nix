{
    hashedPassword,
    host,
    hostname,
    lib,
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
            nix.enable = lib.mkDefault true;
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
}
