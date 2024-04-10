{
    description = "My NixOS Configuration";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home Manager
        home-manager.url = "github:nix-community/home-manager/release-23.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nur.url = "github:nix-community/NUR";

        nixos-wsl.url = "github:nix-community/NixOS-WSL";
        nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

        ags.url = "github:Aylur/ags";
        #
        # hyprlock.url = "github:hyprwm/Hyprlock";
    };

    outputs = inputs:
        with inputs; let 
        secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

    nixpkgsWithOverlays = with inputs; rec {
        config = {
            allowUnfree = true;
            permittedInsecurePackages = [];
        };
        overlays = [
            nur.overlay
                (_final: prev: {
                 unstable = import nixpkgs-unstable {
                 inherit (prev) system;
                 inherit config;
                 };
                 })
        ];
    };

    configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
    };

    home-symlink = { config, source, recursive ? false, ... }: {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${source}";
        recursive = recursive;
    };

    argDefaults = {
        inherit secrets inputs self home-symlink;
        channels = {
            inherit nixpkgs nixpkgs-unstable;
        };
    };

    mkNixosConfiguration = {
        system ? "x86_64-linux",
        hostname,
        username,
        firefoxProfiles,
        args ? {},
        modules,
    }: let
    specialArgs = argDefaults // {inherit hostname username firefoxProfiles;} // args;
    in
        nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = [
                (configurationDefaults specialArgs)
                    home-manager.nixosModules.home-manager
                    # {
                    #     home-manager.users.${username} = {
                    #         imports = [
                    #             hyprlock.homeManagerModules.hyprlock
                    #         ];
                    #     };
                    # }
                    ./base
            ]
            ++ modules;
        };
    in {
        nixosConfigurations = {
            wsl = mkNixosConfiguration {
                hostname = "nixos-wsl";
                username = "jesse";
                modules = [
                    nixos-wsl.nixosModules.wsl
                    ./hosts/wsl
                ];
            };
            linux = mkNixosConfiguration {
                hostname = "nixos";
                username = "jesse";
                modules = [
                    ./base/desktop
                    ./hosts/linux
                ];
                firefoxProfiles = [
                    "oogn6p3n.default"
                    "75nrrokj.Work"
                ];
            };
        };
    };
}
