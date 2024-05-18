{
    version = "23.11";

    nixosConfigs = { mkNixosConfigs, inputs }: mkNixosConfigs [
        {
            name = "desktop";
            hostname = "nixos";
            username = "jesse";
            modules = [
                ./base/desktop
            ];
        }
        {
            name = "wsl";
            hostname = "nixos-wsl";
            username = "jesse";
            modules = [
                inputs.nixos-wsl.nixosModules.wsl
            ];
        }
        {
            name = "nix-pi";
            hostname = "nix-pi";
            username = "jesse";
            system = "aarch64-linux";
            modules = [
                inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ];
        }
    ];
}
