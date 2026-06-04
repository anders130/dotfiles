{
    flake.modules.nixos.jesse-desktop = {
        config,
        pkgs,
        ...
    }: {
        users.groups.dialout.members = config.users.normalUsers;
        environment.systemPackages = [pkgs.chromium];
    };
}
