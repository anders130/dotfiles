{
    inputs,
    secrets,
    variables,
}: let
    mkLib = nxipkgs:
        inputs.nixpkgs.lib.extend (final: prev:
            (import ./lib {
                lib = final;
                inputs = inputs;
            })
            // inputs.home-manager.lib);

    lib = mkLib inputs.nixpkgs;

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
        inherit inputs lib secrets variables;
        self = inputs.self;
        channels = {
            nixpkgs = inputs.nixpkgs;
            nixpkgs-unstable = inputs.nixpkgs-unstable;
        };
    };

    mkNixOnDroidConfig = host @ {
        system ? "x86_64-linux",
        name,
        hostname,
        username,
        hashedPassword ? null,
        args ? {},
        modules,
    }: let
        specialArgs = argDefaults // {inherit hostname username hashedPassword host;} // args;
    in
        inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            inherit system specialArgs;
            modules = modules ++ [
                ./hosts/shared
                ./hosts/${name}
                inputs.home-manager.nixosModules.home-manager
                inputs.stylix.nixosModules.stylix
                (mkHomeManagerConfig specialArgs)
            ];
            pkgs = import inputs.nixpkgs {
                inherit system;
                overlays = [
                    inputs.nix-on-droid.overlays
                ];
            };
        };
in {
    default = mkNixOnDroidConfig {
        system = "aarch64-linux";
        name = "pixnix";
        hostname = "pixnix";
        username = "jesse";
        modules = [
            ./hosts/shared/cli
        ];
    };
}
