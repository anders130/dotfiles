{
    den.default.nixos = {
        config,
        lib,
        ...
    }: {
        networking.networkmanager.enable = true;
        users.groups.networkmanager.members = config.users.normalUsers;
        services.avahi = {
            enable = lib.mkDefault true;
            nssmdns4 = true;
            openFirewall = true;
            publish = {
                enable = true;
                addresses = true;
                workstation = true;
            };
        };
    };
}
