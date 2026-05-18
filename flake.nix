{
    description = "My NixOS Configuration";

    inputs = {
        # essentials
        nixpkgs.url = "nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager?ref=release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        haumea = {
            url = "github:nix-community/haumea/v0.2.2";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        modulix = {
            url = "github:anders130/modulix";
            inputs = {
                haumea.follows = "haumea";
                nixpkgs.follows = "nixpkgs";
            };
        };
        flake-parts.url = "github:hercules-ci/flake-parts";
        stylix = {
            url = "github:danth/stylix/release-25.11";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                systems.follows = "systems";
                flake-parts.follows = "flake-parts";
            };
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-lib = {
            url = "github:anders130/nix-lib";
            inputs = {
                flake-parts.follows = "flake-parts";
                nixpkgs-lib.follows = "nixpkgs";
            };
        };

        ## programs
        nvix = {
            url = "github:anders130/nvix";
            inputs = {
                systems.follows = "systems";
                flake-parts.follows = "flake-parts";
                nix-lib.follows = "nix-lib";
                git-hooks.follows = "pre-commit-hooks";
            };
        };
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs = {
                nixpkgs.follows = "nixpkgs-unstable";
                home-manager.follows = "home-manager";
            };
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixcord = {
            url = "github:kaylorben/nixcord";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                flake-parts.follows = "flake-parts";
                flake-compat.follows = "flake-compat";
            };
        };
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        clock-mate = {
            url = "github:clock-mate/extension";
            inputs = {
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs-unstable";
            };
        };
        catppuccin-qutebrowser = {
            url = "github:catppuccin/qutebrowser";
            flake = false;
        };
        statix = {
            url = "github:oppiliappan/statix";
            inputs = {
                flake-parts.follows = "flake-parts";
                nixpkgs.follows = "nixpkgs-unstable";
                systems.follows = "systems";
            };
        };
        pre-commit-hooks = {
            url = "github:cachix/git-hooks.nix";
            inputs = {
                flake-compat.follows = "flake-compat";
                nixpkgs.follows = "nixpkgs-unstable";
            };
        };
        winapps = {
            url = "github:winapps-org/winapps";
            inputs = {
                flake-compat.follows = "flake-compat";
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs";
            };
        };
        hytale-launcher = {
            url = "github:anders130/hytale-launcher-nix";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        # gui
        hyprland = {
            url = "github:hyprwm/hyprland/v0.54.3";
            inputs = {
                systems.follows = "systems";
                pre-commit-hooks.follows = "";
            };
        };
        hyprsplit = {
            url = "github:shezdy/hyprsplit/v0.54.3";
            inputs.hyprland.follows = "hyprland";
        };
        my-shell = {
            url = "github:anders130/my-shell";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        caelestia-cli = {
            url = "github:caelestia-dots/cli";
            inputs.caelestia-shell.follows = "caelestia-shell";
        };
        caelestia-shell = {
            url = "github:caelestia-dots/shell";
            inputs.caelestia-cli.follows = "caelestia-cli";
        };

        # host specific
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                flake-compat.follows = "flake-compat";
            };
        };
        lanzaboote = {
            url = "github:nix-community/lanzaboote";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lsfg-vk-flake = {
            url = "github:pabloaul/lsfg-vk-flake/main";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    # deduplicate inputs
    inputs = {
        flake-utils = {
            url = "github:numtide/flake-utils";
            inputs.systems.follows = "systems";
        };
        flake-compat.url = "github:edolstra/flake-compat";
        systems.url = "github:nix-systems/default-linux";
    };

    outputs = inputs:
        inputs.nix-lib.lib.mkFlakeFromTree {
            inherit inputs;
            root = ./parts;
            ignore = [];
        };
}
