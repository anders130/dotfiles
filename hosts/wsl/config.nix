inputs: {
    hostName = "nixos-wsl";
    username = "jesse";
    modules = [
        inputs.nixos-wsl.nixosModules.wsl
    ];
}
