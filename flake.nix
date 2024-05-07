{
    description = "My NixOS Configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nur.url = "github:nix-community/NUR";
        ags.url = "github:Aylur/ags";
    };

    outputs = inputs:
        with inputs; let 
        secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
        variables = import ./variables.nix;

        nixpkgsWithOverlays = with inputs; rec {
            config = {
                allowUnfree = true;
                permittedInsecurePackages = [];
            };
            overlays = [
                nur.overlay(_final: prev: {
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

        home-symlink = { config, source, recursive ? false, ... }: {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${source}";
            recursive = recursive;
        };

        argDefaults = {
            inherit secrets variables;
            inherit inputs self home-symlink;
            channels = {
                inherit nixpkgs nixpkgs-unstable;
            };
        };

        mkNixosConfig = host@{
            system ? "x86_64-linux",
            name,
            hostname,
            username,
            args ? {},
            modules,
        }: let
            specialArgs = argDefaults // { inherit hostname username host; } // args;
        in
            nixpkgs.lib.nixosSystem {
                inherit system specialArgs;
                modules = modules ++ [
                    ./base
                    ./hosts/${name}
                    home-manager.nixosModules.home-manager
                    (configurationDefaults specialArgs)
                ];
            };

            mkNixosConfigs = nixosConfigs:
                builtins.mapAttrs (ignored: namedConfig: mkNixosConfig namedConfig) (
                    builtins.listToAttrs(
                        builtins.map(config: {
                            value = config;
                            name = config.name;
                        }) nixosConfigs
                    )
                );
    in {
        nixosConfigurations = variables.nixosConfigs {
            inherit mkNixosConfigs inputs;
        };
    };
}
