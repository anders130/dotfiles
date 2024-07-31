{
    description = "My NixOS Configuration";

    inputs = {
        # essentials
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nur.url = "github:nix-community/NUR";
        stylix.url = "github:danth/stylix";

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # gui
        ags.url = "github:Aylur/ags";
        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

        split-monitor-workspaces = {
            url = "github:Duckonaut/split-monitor-workspaces";
            inputs.hyprland.follows = "hyprland";
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
    };

    outputs = inputs: let
        secrets = builtins.fromJSON (builtins.readFile "${inputs.self}/secrets.json");
        variables = import ./variables.nix;
    in {
        overlays = import ./overlays.nix inputs;

        nixosConfigurations = import ./nixosConfigurations.nix {
            inherit secrets variables inputs;
        };
    };
}
