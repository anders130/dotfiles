inputs: {
    hostName = "nix-pi";
    username = "admin";
    hashedPassword = "$6$35ci2VTHBQagt2F.$D3rDPc2vNQfZwtbm.T5KIXv6CHy//.0aPLYodHuE7TIUV3yaiwXyNgCZ5/vldVhgqvndaUtiu9XAA2jNyglFT1";
    system = "aarch64-linux";
    isThinClient = true;
    modules = with inputs.raspberry-pi-nix.nixosModules; [
        raspberry-pi
        sd-image
    ];
}
