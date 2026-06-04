{
    config,
    inputs,
    lib,
    ...
}: {
    config.flake.lib.mkNixos = system: name: {
        ${name} = inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
                config.flake.modules.nixos.default
                config.flake.modules.nixos.${name}
                {
                    nixpkgs.hostPlatform = lib.mkDefault system;
                    environment.variables.NIX_FLAKE_DEFAULT_HOST = name;
                }
            ];
        };
    };
}
