{inputs, ...}: {
    imports = [
        ../templates
    ];
    flake.nixosConfigurations = inputs.modulix.lib.mkHosts {
        inherit inputs;
        flakePath = "/home/jesse/.dotfiles";
        specialArgs = {
            hashedPassword = null;
            hostName = "nixos";
            isThinClient = false;
            username = "jesse";
        };
        sharedConfig = {
            imports = [inputs.self.modules.nixos.default];
        };
    };
}
