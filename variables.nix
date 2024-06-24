{
    version = "24.05";

    nixosConfigs = { mkNixosConfigs, inputs }: mkNixosConfigs [
        {
            name = "desktop";
            hostname = "nixos";
            username = "jesse";
            modules = [
                inputs.disko.nixosModules.disko
                ./hosts/shared/cli
                ./hosts/shared/desktop
            ];
        }
        {
            name = "wsl";
            hostname = "nixos-wsl";
            username = "jesse";
            modules = [
                inputs.nixos-wsl.nixosModules.wsl
                ./hosts/shared/cli
            ];
        }
        {
            name = "nix-pi";
            hostname = "nix-pi";
            username = "admin";
            hashedPassword = "$6$35ci2VTHBQagt2F.$D3rDPc2vNQfZwtbm.T5KIXv6CHy//.0aPLYodHuE7TIUV3yaiwXyNgCZ5/vldVhgqvndaUtiu9XAA2jNyglFT1";
            system = "aarch64-linux";
            modules = [
                inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ];
        }
    ];
}
