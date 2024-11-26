{username, ...}: {
    imports = [
        ./wsl.nix
    ];

    config = {
        virtualisation.docker = {
            enable = true;
            enableOnBoot = true;
            autoPrune.enable = true;
        };

        users.users.${username}.extraGroups = [
            "docker"
        ];
    };
}
