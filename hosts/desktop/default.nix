{username, ...}: {
    imports = [
        ./hardware-configuration.nix
        ./disk-config.nix
    ];

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    modules = {
        virt-manager.enable = true;
        nvidia.enable = true;
    };

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
