inputs: final: prev: {
    inherit (inputs.winapps.packages.${prev.stdenv.hostPlatform.system}) winapps winapps-launcher;
}
