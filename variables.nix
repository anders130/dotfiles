{
    version = "23.11";

    nixosConfigs = { mkNixosConfigs, inputs }: mkNixosConfigs [
        {
            name = "linux";
            hostname = "nixos";
            username = "jesse";
            modules = [
                ./base/desktop
                ./hosts/linux
            ];
        }
        {
            name = "wsl";
            hostname = "nixos-wsl";
            username = "jesse";
            modules = [
                inputs.nixos-wsl.nixosModules.wsl
                ./hosts/wsl
            ];
        }
    ];
}
