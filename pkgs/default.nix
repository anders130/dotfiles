{inputs, ...}: let
    inherit (inputs.haumea.lib) load loaders;
in {
    perSystem = {pkgs, ...}: {
        packages = load {
            src = ./.;
            loader = loaders.callPackage;
            transformer = _: mod: removeAttrs mod ["default"];
            inputs = removeAttrs pkgs ["root" "super"];
        };
    };
}
