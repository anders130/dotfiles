inputs: {
    hostName = "nixos";
    username = "jesse";
    modules = [
        inputs.disko.nixosModules.disko
    ];
}
