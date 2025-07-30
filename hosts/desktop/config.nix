inputs: {
    hostName = "nixos";
    username = "jesse";
    modules = with inputs; [
        disko.nixosModules.disko
        lsfg-vk-flake.nixosModules.default
    ];
}
