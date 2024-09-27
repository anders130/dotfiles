inputs: {
    hostname = "nixos";
    username = "jesse";
    modules = [
        inputs.disko.nixosModules.disko
    ];
}
