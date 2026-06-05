{
    den.aspects.jesse-desktop.nixos = {
        config,
        pkgs,
        ...
    }: {
        users.groups.dialout.members = config.users.normalUsers;
        environment.systemPackages = [pkgs.chromium];
    };
}
