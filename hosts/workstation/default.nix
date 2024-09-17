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

    modules.hardware = {
        amdgpu.enable = true;
        displaylink.enable = true;
    };
}
