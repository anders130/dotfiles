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
        lib = nixpkgs.lib.extend (final: prev: import ./lib);
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
            inherit pkgs lib;
            module = import ./config;
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in {
        checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        packages.default = nvim;
    });
}
