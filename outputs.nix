inputs:
inputs.nix-lib.lib.mkFlakeFromTree {
    inherit inputs;
    root = ./.;
    ignore = [
        "flake.nix"
        "outputs.nix"
        "templates"
    ];
}
