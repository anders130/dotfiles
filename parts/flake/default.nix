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

        # host specific
        disko.url = "github:nix-community/disko";
        nixos-wsl.url = "github:nix-community/NixOS-WSL";
        lanzaboote.url = "github:nix-community/lanzaboote";
        lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    };
}
