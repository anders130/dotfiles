inputs: final: prev: {
    inherit (inputs.hytale-launcher.packages.${prev.stdenv.hostPlatform.system}) hytale-launcher;
}
