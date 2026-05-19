{inputs, ...}: {
    flake-file.inputs.home-manager = {
        url = "github:nix-community/home-manager/release-25.11";
    };
    flake.modules.nixos.default = {
        imports = [inputs.home-manager.nixosModules.home-manager];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
        };
    };
}
