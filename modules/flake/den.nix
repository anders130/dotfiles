{inputs, ...}: {
    flake-file.inputs.den.url = "github:denful/den";
    imports = [inputs.den.flakeModule];
}
