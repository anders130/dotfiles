{
    inputs,
    secrets,
    variables,
}: let
    mkLib = system:
        inputs.nixpkgs.lib.extend (final: prev:
            (import ./lib {
                inherit inputs system;
                lib = final;
            })
            // inputs.home-manager.lib);

    mkNixosConfig = host @ {
        name,
        hostname,
        username,
        system ? "x86_64-linux",
        hashedPassword ? null,
        modules ? [],
        args ? {},
    }: let
        lib = mkLib system;
        specialArgs = {
            inherit inputs secrets variables;
            inherit hashedPassword hostname username;
            inherit host lib;
        } // args;
    in
        inputs.nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = modules ++ [
                ./hosts/shared
                ./hosts/${name}
                inputs.home-manager.nixosModules.home-manager
                inputs.stylix.nixosModules.stylix
                {
                    home-manager.extraSpecialArgs = specialArgs;
                }
            ];
        };

    mkNixosConfigs = nixosConfigs:
        builtins.mapAttrs (ignored: namedConfig: mkNixosConfig namedConfig) (
            builtins.listToAttrs (
                builtins.map (config: {
                    value = config;
                    name = config.name;
                })
                nixosConfigs
            )
        );
in variables.nixosConfigs {
    inherit mkNixosConfigs inputs;
}
