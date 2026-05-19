{inputs, ...}: {
    imports = [
        ../overlays
        ../pkgs
        ../templates
    ];
    flake.nixosConfigurations = inputs.modulix.lib.mkHosts {
        inherit inputs;
        flakePath = "/home/jesse/.dotfiles";
        modulesPath = ../modules;
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
            modules.bundles.shared.enable = true;
        };
    };
}
