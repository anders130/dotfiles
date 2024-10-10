inputs: let
    variables = import ../variables.nix;

    mkLib = {system, isThinClient}:
        inputs.nixpkgs.lib.extend (final: prev:
            (import ../lib {
                inherit inputs system isThinClient;
                lib = final;
            })
            // inputs.home-manager.lib);

    mkNixosConfig = host @ {
        name,
        hostname,
        username,
        hashedPassword ? null,
        system ? "x86_64-linux",
        isThinClient ? false,
        modules ? [],
    }: let
        lib = mkLib {inherit system isThinClient;};
        specialArgs = {
            inherit inputs variables;
            inherit hashedPassword hostname username;
            inherit host lib;
        };
    in
        inputs.nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = modules ++ [
                ../modules
                ./shared
                ./${name}
                inputs.home-manager.nixosModules.home-manager
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

    # get all the config.nix files in the host directories
    hosts = let
        configExists = name: builtins.pathExists ./${name}/config.nix;
        importConfig = name: (import ./${name}/config.nix inputs);
        enrichConfig = name: (importConfig name) // {inherit name;};

        dirContent = builtins.attrNames (builtins.readDir ./.);
        configDirs = builtins.filter configExists dirContent;
    in
        builtins.map enrichConfig configDirs;
in
    mkNixosConfigs hosts
