{
    username,
    ...
}: {
    imports = [
        ./disk-config.nix
        ./hardware-configuration.nix
    ];

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    bundles = {
        cli.enable = true;
        desktop.enable = true;
    };
}
