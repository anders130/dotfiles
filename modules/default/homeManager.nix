{inputs, ...}: {
    flake-file.inputs.home-manager.url = "github:nix-community/home-manager";
    flake.modules.nixos.default = {
        imports = [inputs.home-manager.nixosModules.home-manager];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            sharedModules = [inputs.self.modules.homeManager.default];
        };
    };
}
