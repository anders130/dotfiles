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
        hardware.nvidia.enable = true;
        virt-manager.enable = true;
    };

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
