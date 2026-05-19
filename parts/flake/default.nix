{inputs, ...}: {
    imports = [inputs.flake-file.flakeModules.default];
    flake-file.description = "My NixOS Configuration";
    flake-file.inputs = {
        flake-file.url = "github:denful/flake-file";
        nix-lib.url = "github:anders130/nix-lib";
        treefmt-nix.url = "github:anders130/treefmt-nix";
        wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

        # essentials
        nixpkgs.url = "nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
        haumea.url = "github:nix-community/haumea/v0.2.2";
        modulix.url = "github:anders130/modulix";
        stylix.url = "github:danth/stylix/release-25.11";
        sops-nix.url = "github:Mic92/sops-nix";

        # programs
        nvix = {
            url = "github:anders130/nvix";
            inputs.nix-lib.follows = "nix-lib";
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        nixcord.url = "github:kaylorben/nixcord";
        nix-index-database.url = "github:nix-community/nix-index-database";
        clock-mate = {
            url = "github:clock-mate/extension";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        catppuccin-qutebrowser = {
            url = "github:catppuccin/qutebrowser";
            flake = false;
        };
        statix = {
            url = "github:oppiliappan/statix";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        winapps.url = "github:winapps-org/winapps";
        hytale-launcher = {
            url = "github:anders130/hytale-launcher-nix";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        # gui
        hyprland = {
            url = "github:hyprwm/hyprland/v0.54.3";
            inputs.pre-commit-hooks.follows = "";
        };
        hyprsplit = {
            url = "github:shezdy/hyprsplit/v0.54.3";
            inputs.hyprland.follows = "hyprland";
        };
        my-shell.url = "github:anders130/my-shell";
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
