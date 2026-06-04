{inputs, ...}: {
    flake.modules.nixos.default = {
        imports = with inputs.self.modules.nixos; [
            jesse
            sops
            ssh
            nix
            nh
            nvix
            fish
        ];
        home-manager.sharedModules = with inputs.self.modules.homeManager; [
            cli
            nix-index
            btop
        ];
    };
}
