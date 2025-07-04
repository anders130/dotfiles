{inputs, ...}: let
    inherit (inputs.haumea.lib) load transformers;
    load' = src: {pkgs, ...} @ args:
        load {
            inherit src;
            transformer = transformers.liftDefault;
            inputs =
                args;
                # // {
                #     inherit inputs;
                # };
        };
in {
    flake = {
        homeModules.default = load' ./home;
        nixosModules.default = load' ./nixos;
    };
}
