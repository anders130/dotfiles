{
    description = "My NixOS Configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        nur.url = "github:nix-community/NUR";
        ags.url = "github:Aylur/ags";

        nix-index-database = {
            url = "github:nix-community/nix-index-database?rev=4ac3639cebb6286f1a68d015b80e9e0c6c869ce6";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs: let
        secrets = builtins.fromJSON (builtins.readFile "${inputs.self}/secrets.json");
        variables = import ./variables.nix;
    in {
        overlays = import ./overlays.nix inputs;

        nixosConfigurations = import ./nixosConfigurations.nix {
            inherit secrets variables inputs;
        };
    };
}
