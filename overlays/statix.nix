inputs: final: prev: {
    inherit (inputs.statix.packages.${prev.system}) statix;
}
