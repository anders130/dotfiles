{
    config,
    inputs,
    username,
    ...
}: {
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];

    config.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.${username}.home = {
            inherit username;
            stateVersion = config.system.stateVersion;
            homeDirectory = "/home/${username}";
        };
    };
}
