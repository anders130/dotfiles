inputs: {
    hostname = "nix-workstation";
    username = "jesse";
    modules = [
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
    ];
}
