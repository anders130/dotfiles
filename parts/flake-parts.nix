{inputs, ...}: {
    flake-file.inputs.flake-parts.url = "github:hercules-ci/flake-parts";
    imports = [inputs.flake-parts.flakeModules.modules];
}
