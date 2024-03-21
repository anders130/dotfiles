{
    description = "My NixOS Configuration";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager/release-23.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nur.url = "github:nix-community/NUR";

        nixos-wsl.url = "github:nix-community/NixOS-WSL";
        nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

        nix-index-database.url = "github:Mic92/nix-index-database";
        nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs:
        with inputs; let 
        secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

    nixpkgsWithOverlays = with inputs; rec {
        config = {
            allowUnfree = true;
            permittedInsecurePackages = [];
        };
        overlays = [
            nur.overlay
                (_final: prev: {
                 unstable = import nixpkgs-unstable {
                 inherit (prev) system;
                 inherit config;
                 };
                 })
        ];
    };

    configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
    };

    argDefaults = {
        inherit secrets inputs self nix-index-database;
        channels = {
            inherit nixpkgs nixpkgs-unstable;
        };
    };

    mkNixosConfiguration = {
        system ? "x86_64-linux",
        hostname,
        username,
        args ? {},
        modules,
    }: let
    specialArgs = argDefaults // {inherit hostname username;} // args;
    in
        nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
                (configurationDefaults specialArgs)
                    home-manager.nixosModules.home-manager
                    ./system.nix
            ]
            ++ modules;
        };
    in {
        nixosConfigurations = {
            wsl = mkNixosConfiguration {
                hostname = "nixos-wsl";
                username = "jesse";
                modules = [
                    nixos-wsl.nixosModules.wsl
                    ./hosts/wsl
                ];
            };
            linux = mkNixosConfiguration {
                hostname = "nixos";
                username = "jesse";
                modules = [
                    ./hosts/linux
                ];
            };
        };
    };
}
