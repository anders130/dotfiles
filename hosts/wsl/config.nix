inputs: {
    hostname = "nixos-wsl";
    username = "jesse";
    modules = [
        inputs.nixos-wsl.nixosModules.wsl
    ];
}
