{
    config,
    lib,
    ...
}: {
    flake.lib.mkUser = username: isAdmin: {
        nixos.${username} = {
            imports = [(lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])];
            users.users.${username} = {
                isNormalUser = true;
                home = "/home/${username}";
                extraGroups = lib.optionals isAdmin ["wheel"];
            };
            home-manager.users.${username} = {
                imports = [config.flake.modules.homeManager.${username}];
            };
        };
        homeManager.${username}.home = {
            inherit username;
            homeDirectory = "/home/${username}";
        };
    };
}
