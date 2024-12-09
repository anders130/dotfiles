{
    config,
    inputs,
    lib,
    username,
    ...
}: {
    imports = [
        inputs.home-manager.nixosModules.home-manager
        (lib.modules.mkAliasOptionModule ["hm"] ["home-manager" "users" username])
    ];

    home-manager = {
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
