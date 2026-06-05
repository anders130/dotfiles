{inputs, ...}: {
    # reusable aspects live under the `dots` namespace, exported as
    # flake.denful.dots so other flakes can consume them:
    #   imports = [ (inputs.den.namespace "dots" [inputs.this-flake]) ];
    imports = [(inputs.den.namespace "dots" true)];
}
