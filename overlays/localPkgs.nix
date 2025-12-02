inputs: final: prev: {
    local = inputs.self.packages.${prev.stdenv.hostPlatform.system};
}
