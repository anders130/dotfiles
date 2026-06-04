# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
    description = "My NixOS Configuration";

    outputs = inputs: import ./outputs.nix inputs;

    inputs = {
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
        catppuccin-qutebrowser = {
            url = "github:catppuccin/qutebrowser";
            flake = false;
        };
        clock-mate = {
            url = "github:clock-mate/extension";
            inputs = {
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs";
            };
        };
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        files = {
            url = "github:mightyiam/files";
            flake = false;
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-compat.url = "github:edolstra/flake-compat";
        flake-file.url = "github:denful/flake-file";
        flake-follows.url = "github:anders130/flake-follows";
        flake-parts = {
            url = "github:hercules-ci/flake-parts";
            inputs.nixpkgs-lib.follows = "nixpkgs-lib";
        };
        flake-utils = {
            url = "github:numtide/flake-utils";
            inputs.systems.follows = "systems";
        };
        git-hooks = {
            url = "github:cachix/git-hooks.nix";
            inputs = {
                flake-compat.follows = "flake-compat";
                nixpkgs.follows = "nixpkgs";
            };
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland = {
            url = "github:hyprwm/hyprland/v0.55.2";
            inputs = {
                pre-commit-hooks.follows = "";
                systems.follows = "systems";
            };
        };
        hyprsplit = {
            url = "github:shezdy/hyprsplit";
            inputs = {
                hyprland.follows = "hyprland";
                nixpkgs.follows = "nixpkgs";
            };
        };
        hytale-launcher = {
            url = "github:anders130/hytale-launcher-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        import-tree.url = "github:denful/import-tree";
        lanzaboote = {
            url = "github:nix-community/lanzaboote";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lsfg-vk-flake = {
            url = "github:pabloaul/lsfg-vk-flake/main";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-lib = {
            url = "github:anders130/nix-lib";
            inputs = {
                flake-parts.follows = "flake-parts";
                import-tree.follows = "import-tree";
                nixpkgs-lib.follows = "nixpkgs-lib";
            };
        };
        nixcord = {
            url = "github:kaylorben/nixcord";
            inputs = {
                flake-compat.follows = "flake-compat";
                flake-parts.follows = "flake-parts";
                nixpkgs.follows = "nixpkgs";
            };
        };
        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs = {
                flake-compat.follows = "flake-compat";
                nixpkgs.follows = "nixpkgs";
            };
        };
        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-lib.follows = "nixpkgs";
        nvix = {
            url = "github:anders130/nvix";
            inputs = {
                flake-parts.follows = "flake-parts";
                git-hooks.follows = "git-hooks";
                nix-lib.follows = "nix-lib";
                systems.follows = "systems";
            };
        };
        project = {
            url = "github:anders130/project";
            inputs = {
                flake-parts.follows = "flake-parts";
                import-tree.follows = "import-tree";
                nixpkgs.follows = "nixpkgs";
            };
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:danth/stylix";
            inputs = {
                flake-parts.follows = "flake-parts";
                nixpkgs.follows = "nixpkgs";
                systems.follows = "systems";
            };
        };
        systems.url = "github:nix-systems/default-linux";
        treefmt-nix = {
            url = "github:anders130/treefmt-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        winapps = {
            url = "github:winapps-org/winapps";
            inputs = {
                flake-compat.follows = "flake-compat";
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs";
            };
        };
        wrapper-modules = {
            url = "github:BirdeeHub/nix-wrapper-modules";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs = {
                home-manager.follows = "home-manager";
                nixpkgs.follows = "nixpkgs";
            };
        };
    };
}
