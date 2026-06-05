{
    den.default.nixos = {config, ...}: {
        networking.networkmanager.enable = true;
        users.groups.networkmanager.members = config.users.normalUsers;
    };
}
