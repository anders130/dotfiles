inputs: final: prev: {
    inherit (inputs.nixpkgs-immich.legacyPackages.${prev.system}) immich;
}
