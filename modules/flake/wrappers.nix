{inputs, ...}: {
    flake-file.inputs.wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    imports = [inputs.wrapper-modules.flakeModules.wrappers];
}
