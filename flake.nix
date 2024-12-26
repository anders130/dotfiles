{
    description = "My NixOS Configuration";

    inputs = {
        # essentials
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";

        home-manager = {
            url = "github:nix-community/home-manager?ref=release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        stylix.url = "github:danth/stylix";

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nvix.url = "github:anders130/nvix";
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        nixcord.url = "github:kaylorben/nixcord";
        lumehub.url = "git+https://github.com/LumeHub/LumeHub.Server?branch=dev&submodules=1";
        nix-xilinx = {
            url = "gitlab:doronbehar/nix-xilinx";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser.url = "github:0xc000022070/zen-browser-flake";
        zenix = {
            url = "github:anders130/zenix";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
        nur.url = "github:nix-community/NUR";

        # gui
        ags.url = "github:Aylur/ags/v1";
        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            ref = "refs/tags/v0.45.2";
            submodules = true;
        };

        split-monitor-workspaces = {
            type = "git";
            url = "https://github.com/Duckonaut/split-monitor-workspaces";
            rev = "4aee4a6d67f8714fedd33acc7c9e64befba9b5cb";
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
        raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

        lanzaboote = {
            url = "github:nix-community/lanzaboote";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs: {
        nixosConfigurations = import ./hosts inputs;

        overlays = import ./overlays inputs;

        templates = import ./templates;
    };
}
