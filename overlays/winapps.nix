inputs: final: prev: {
    inherit (inputs.winapps.packages.${prev.system}) winapps winapps-launcher;
}
