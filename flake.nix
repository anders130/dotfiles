{
    description = "My NixOS Configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        nur.url = "github:nix-community/NUR";
        ags.url = "github:Aylur/ags";
    };

    outputs = inputs:
        with inputs; let
        secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
        variables = import ./variables.nix;
        home-symlink = import ./lib/home-symlink.nix;

        overlay = final: super: {
            makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
        };

        nixpkgsWithOverlays = with inputs; rec {
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
                permittedInsecurePackages = [];
            };
            overlays = [
                overlay
                nur.overlay(_final: prev: {
                     unstable = import nixpkgs-unstable {
                        inherit (prev) system;
                        inherit config;
                     };
                     local = import ./pkgs {
                        inherit (prev) system;
                        pkgs = import nixpkgs {
                           inherit (prev) system;
                           inherit config;
                        };
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
            inherit secrets variables home-symlink;
            inherit inputs self;
            channels = {
                inherit nixpkgs nixpkgs-unstable;
            };
        };

        mkNixosConfig = host@{
            system ? "x86_64-linux",
            name,
            hostname,
            username,
            hashedPassword ? null,
            args ? {},
            modules,
        }: let
            specialArgs = argDefaults // { inherit hostname username hashedPassword host; } // args;
        in nixpkgs.lib.nixosSystem {
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
