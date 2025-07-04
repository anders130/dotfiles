{inputs, ...}: let
    inherit (builtins) mapAttrs readDir;
    inherit (inputs.haumea.lib) load transformers;
    loadModules = p:
        p
        |> readDir
        |> mapAttrs (n: _: {pkgs, ...} @ args:
            load {
                src = p + "/${n}";
                transformer = transformers.liftDefault;
                inputs = args // {inherit pkgs;};
            });
in {
    flake = {
        homeModules = loadModules ./home;
        nixosModules = loadModules ./nixos;
    };
}
