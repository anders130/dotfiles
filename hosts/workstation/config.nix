inputs: {
    hostName = "nix-workstation";
    username = "jesse";
    modules = [
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nix-easyroam.nixosModules.nix-easyroam
    ];
}
