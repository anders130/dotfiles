{inputs, ...}: {
    imports = [inputs.flake-file.flakeModules.default];

    flake-file.description = "My NixOS Configuration";
    flake-file.inputs = {
        flake-file.url = "github:denful/flake-file";
        nix-lib.url = "github:anders130/nix-lib";
        treefmt-nix.url = "github:anders130/treefmt-nix";
        wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

        # essentials
        nixpkgs.url = "nixpkgs/nixos-unstable";
        haumea.url = "github:nix-community/haumea/v0.2.2";
        modulix.url = "github:anders130/modulix";

        # programs
        project = {
            url = "github:anders130/project";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nvix = {
            url = "github:anders130/nvix";
            inputs.nix-lib.follows = "nix-lib";
        };
        nixcord.url = "github:kaylorben/nixcord";
        nix-index-database.url = "github:nix-community/nix-index-database";
        clock-mate = {
            url = "github:clock-mate/extension";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # gui
        caelestia-cli = {
            url = "github:caelestia-dots/cli";
            inputs = {
                caelestia-shell.follows = "caelestia-shell";
                nixpkgs.follows = "caelestia-shell/nixpkgs";
            };
        };
        caelestia-shell = {
            url = "github:caelestia-dots/shell";
            inputs.caelestia-cli.follows = "caelestia-cli";
        };

        # host specific
        disko.url = "github:nix-community/disko";
        nixos-wsl.url = "github:nix-community/NixOS-WSL";
        lanzaboote.url = "github:nix-community/lanzaboote";
        lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    };
}
