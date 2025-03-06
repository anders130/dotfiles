{
    description = "My NixOS Configuration";

    inputs = {
        # essentials
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        nur.url = "github:nix-community/NUR";
        home-manager = {
            url = "github:nix-community/home-manager?ref=release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        modulix = {
            url = "github:anders130/modulix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:danth/stylix/release-24.11";
            inputs.home-manager.follows = "home-manager";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ## programs
        nvix.url = "github:anders130/nvix";
        zenix = {
            url = "github:anders130/zenix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        nixcord.url = "github:kaylorben/nixcord";
        lumehub.url = "github:LumeHub/LumeHub.Server?ref=dev";
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        clock-mate.url = "github:anders130/clock-mate";

        # gui
        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            ref = "refs/tags/v0.47.1";
            submodules = true;
        };
        split-monitor-workspaces = {
            type = "git";
            url = "https://github.com/Duckonaut/split-monitor-workspaces";
            inputs.hyprland.follows = "hyprland";
        };
        my-shell = {
            url = "github:anders130/my-shell";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # host specific
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
        lanzaboote = {
            url = "github:nix-community/lanzaboote";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs: let
        forAllSystems = inputs.nixpkgs.lib.genAttrs [
            "aarch64-linux"
            "x86_64-linux"
        ];
    in {
        nixosConfigurations = inputs.modulix.lib.mkHosts {
            inherit inputs;
            flakePath = "/home/jesse/.dotfiles";
            modulesPath = ./modules;
            specialArgs = {
                hashedPassword = null;
                hostname = "nixos";
                isThinClient = false;
                username = "jesse";
            };
            helpers = inputs.home-manager.lib;
            sharedConfig = {
                modules.bundles.shared.enable = true;
            };
        };

        packages = forAllSystems (system:
            import ./pkgs {
                inherit system;
                pkgs = inputs.nixpkgs.legacyPackages.${system};
            });

        overlays = import ./overlays inputs;

        templates = import ./templates;
    };
}
