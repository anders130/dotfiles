{
    den,
    dots,
    ...
}: {
    flake-file.inputs.home-manager.url = "github:nix-community/home-manager";
    dots.home-manager = {
        nixos.home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
        };
        homeManager = {
            lib,
            osConfig,
            ...
        }: {
            home.stateVersion = lib.mkDefault osConfig.system.stateVersion;
        };
    };
    den = {
        schema.user.classes = ["homeManager"];
        default.includes = [
            dots.home-manager
            den.batteries.host-aspects
        ];
    };
}
