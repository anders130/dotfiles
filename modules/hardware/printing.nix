{
    den.aspects.printing.nixos = {
        config,
        pkgs,
        ...
    }: {
        services.printing = {
            enable = true;
            drivers = [pkgs.hplipWithPlugin];
        };
        hardware.sane = {
            enable = true;
            extraBackends = [pkgs.hplipWithPlugin];
            drivers.scanSnap.enable = true;
        };
        users.groups.scanner.members = config.users.normalUsers;
        users.groups.lp.members = config.users.normalUsers;
    };
}
