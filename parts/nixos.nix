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
        helpers =
            inputs.home-manager.lib
            // (inputs.haumea.lib.load {
                src = ../lib;
                inputs = {inherit (inputs.nixpkgs) lib;};
            });
        sharedConfig = {
            imports = [inputs.self.modules.nixos.default];
        };
    };
}
