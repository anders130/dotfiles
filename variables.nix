{
    version = "24.05";

    nixosConfigs = {
        mkNixosConfigs,
        inputs,
    }: mkNixosConfigs [
        {
            name = "desktop";
            hostname = "nixos";
            username = "jesse";
            modules = [
                inputs.disko.nixosModules.disko
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
            username = "admin";
            hashedPassword = "$6$35ci2VTHBQagt2F.$D3rDPc2vNQfZwtbm.T5KIXv6CHy//.0aPLYodHuE7TIUV3yaiwXyNgCZ5/vldVhgqvndaUtiu9XAA2jNyglFT1";
            system = "aarch64-linux";
            modules = [
                inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            ];
        }
        {
            name = "nebulon";
            hostname = "nebulon";
            username = "admin";
            hashedPassword = "$y$j9T$5HydBWHhlLVkjEEm/WZI01$N79QR3IDbB0wSfLkpmeL4O7pckifOwGWeIwYXnpgj09";
        }
        {
            name = "orbit-station";
            hostname = "orbit-station";
            username = "admin";
            hashedPassword = "$y$j9T$cWy2dB86.mJtVDAlZ683p/$Tf2aTkLcbRraG5a1u4qHNJGDSqd0Q10drnfZ.FX2590";
            system = "aarch64-linux";
            modules = [
                inputs.nixos-hardware.nixosModules.raspberry-pi-4
            ];
        }
    ];
}
