{inputs, ...}: let
    inherit (inputs.haumea.lib) load loaders;
    inherit (builtins) removeAttrs;
in {
    perSystem = {pkgs, ...}: {
        packages = load {
            src = ./.;
            loader = loaders.callPackage;
            transformer = _: mod: removeAttrs mod ["default"];
            inputs = removeAttrs pkgs ["root"];
        };
    };
}
