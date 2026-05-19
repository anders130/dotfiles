{
    flake.modules.nixos.default = {
        config,
        hostName,
        ...
    }: {
        networking = {
            inherit hostName;
            networkmanager.enable = true;
        };
        users.groups.networkmanager.members = config.users.normalUsers;
    };
}
