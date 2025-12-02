inputs: final: prev: {
    inherit (inputs.statix.packages.${prev.stdenv.hostPlatform.system}) statix;
}
