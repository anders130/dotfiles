{
    flake.modules.nixos.default = {config, ...}: {
        networking.networkmanager.enable = true;
        users.groups.networkmanager.members = config.users.normalUsers;
    };
}
