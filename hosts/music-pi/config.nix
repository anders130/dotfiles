inputs: {
    username = "admin";
    hashedPassword = "$y$j9T$GkrYZWVm1LhBrR8230GUI1$HL4C4Wj8X2yXHF6AsBt5CL6W6RykuSfeNAD/BSkB6C2";
    system = "aarch64-linux";
    isThinClient = true;
    modules = [
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];
}
