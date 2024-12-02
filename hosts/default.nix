inputs: let
    inherit (builtins) attrNames filter listToAttrs mapAttrs pathExists readDir;

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
            inherit inputs;
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
in ./.
    |> readDir
    |> attrNames # get all dir names
    |> filter (n: pathExists ./${n}/config.nix) # filter out all dirs that don't have a config.nix
    |> map (n: {
        name = n;
        value = (import ./${n}/config.nix inputs) // {name = n;};
    }) # convert the dir names to attrs with the config.nix as the value
    |> listToAttrs # convert the list to an attrset
    |> mapAttrs (_: config: mkNixosConfig config) # convert the attrset to nixosConfigs
