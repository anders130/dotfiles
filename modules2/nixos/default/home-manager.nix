{username}: {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    users.${username}.home = {
        inherit username;
        homeDirectory = "/home/${username}";
    };
}
