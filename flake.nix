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
        stylix.url = "github:danth/stylix/release-24.05";

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim.url = "path:./modules/nixvim";
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        nixcord.url = "github:kaylorben/nixcord";
        lumehub.url = "git+https://github.com/LumeHub/LumeHub.Server?branch=dev&submodules=1";
        nix-xilinx = {
            url = "gitlab:doronbehar/nix-xilinx";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # gui
        ags.url = "github:Aylur/ags";
        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            ref = "refs/tags/v0.41.2";
            submodules = true;
        };

        split-monitor-workspaces = {
            type = "git";
            url = "https://github.com/Duckonaut/split-monitor-workspaces";
            rev = "d6b4d18ed4a54d336b7fea71c2d3f476a41fbd96";
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

        lanzaboote.url = "github:nix-community/lanzaboote";
    };

    outputs = inputs: {
        nixosConfigurations = import ./hosts inputs;

        overlays = import ./overlays inputs;

        templates = import ./templates;
    };

    nixConfig = {
        extra-substituters = [
            "https://anders130.cachix.org"
        ];
        extra-trusted-public-keys = [
            "anders130.cachix.org-1:mCAq0L6Ld3lG7gxJVHGzKr2rqUZ5qs5YoERxoSjMOXs="
        ];
    };
}
