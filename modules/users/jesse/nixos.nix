{
    flake.modules.nixos.jesse = {pkgs, ...}: {
        users.users.jesse = {
            extraGroups = ["i2c"]; # needed for brightness slider
            shell = pkgs.fish;
        };
    };
}
