{
    description = "Nixvim flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixvim.url = "github:nix-community/nixvim";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = {
        nixpkgs,
        nixvim,
        flake-utils,
        ...
    }: flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
            inherit pkgs;
            module = import ./config;
            extraSpecialArgs = {
                # inherit (inputs) foo;
            };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in {
        checks = {
             # Run `nix flake check .` to verify that your config is not broken
             default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
        };
    });
}
