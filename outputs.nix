inputs:
inputs.nix-lib.lib.mkFlakeFromTree {
    inherit inputs;
    root = ./parts;
    ignore = [];
}
