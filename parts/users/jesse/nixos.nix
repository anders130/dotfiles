{
    flake.modules.nixos.jesse = {
        users.users.jesse.extraGroups = ["i2c"]; # needed for brightness slider
    };
}
