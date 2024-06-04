{
    secrets,
    variables,
    inputs
}: with inputs; let
    home-symlink = import ./lib/home-symlink.nix;

    mkHomeManagerConfig = args: {
        nixpkgs = {
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
                permittedInsecurePackages = [];
            };
            overlays = [(import ./overlays.nix inputs).default];
        };
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = args;
        };
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
            (mkHomeManagerConfig specialArgs)
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
in variables.nixosConfigs {
    inherit mkNixosConfigs inputs;
}
