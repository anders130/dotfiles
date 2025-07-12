inputs: {
    hostName = "orbit-station";
    username = "admin";
    hashedPassword = "$y$j9T$cWy2dB86.mJtVDAlZ683p/$Tf2aTkLcbRraG5a1u4qHNJGDSqd0Q10drnfZ.FX2590";
    system = "aarch64-linux";
    isThinClient = true;
    modules = [
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];
}
