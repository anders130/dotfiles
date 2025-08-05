{
    description = "My NixOS Configuration";

    inputs = {
        # essentials
        nixpkgs.url = "nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
        nur = {
            url = "github:nix-community/NUR";
            inputs = {
                nixpkgs.follows = "nixpkgs-unstable";
                flake-parts.follows = "flake-parts";
            };
        };
        home-manager = {
            url = "github:nix-community/home-manager?ref=release-25.05";
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
        systems.url = "github:nix-systems/default-linux";
        stylix = {
            url = "github:danth/stylix/release-25.05";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                systems.follows = "systems";
                nur.follows = "nur";
                flake-parts.follows = "flake-parts";
            };
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lix-module = {
            url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                flake-utils.follows = "flake-utils";
            };
        };

        ## programs
        nvix = {
            url = "github:anders130/nvix";
            inputs = {
                systems.follows = "systems";
                flake-parts.follows = "flake-parts";
                nixpkgs.follows = "nixpkgs-unstable";
            };
        };
        zenix = {
            url = "github:anders130/zenix";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                home-manager.follows = "home-manager";
                flake-parts.follows = "flake-parts";
            };
        };
        nix-minecraft = {
            url = "github:Infinidoge/nix-minecraft";
            inputs = {
                flake-compat.follows = "flake-compat";
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs-unstable";
            };
        };
        nixcord = {
            url = "github:kaylorben/nixcord?rev=0e0a11de2a3df4356b5f84e81821db507e409ca9";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                flake-parts.follows = "flake-parts";
                flake-compat.follows = "flake-compat";
            };
        };
        lumehub = {
            url = "github:LumeHub/LumeHub.Server?ref=dev";
            inputs = {
                nixpkgs.follows = "nixpkgs-unstable";
                flake-parts.follows = "flake-parts";
            };
        };
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        clock-mate = {
            url = "github:clock-mate/extension/dev";
            inputs = {
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs-unstable";
            };
        };
        catppuccin-qutebrowser = {
            url = "github:catppuccin/qutebrowser";
            flake = false;
        };
        authentik-nix = {
            url = "github:nix-community/authentik-nix";
            inputs = {
                flake-compat.follows = "flake-compat";
                flake-parts.follows = "flake-parts";
                flake-utils.follows = "flake-utils";
                nixpkgs.follows = "nixpkgs-unstable";
                systems.follows = "systems";
            };
        };
        statix = {
            url = "github:RobWalt/statix?rev=support-pipe-operator";
            inputs = {
                flake-parts.follows = "flake-parts";
                nixpkgs.follows = "nixpkgs";
                systems.follows = "systems";
            };
        };
        nixpkgs-immich.url = "github:anders130/nixpkgs";
        pre-commit-hooks = {
            url = "github:cachix/git-hooks.nix";
            inputs = {
                flake-compat.follows = "flake-compat";
                nixpkgs.follows = "nixpkgs";
            };
        };

        # gui
        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            ref = "refs/tags/v0.50.1";
            submodules = true;
            inputs.systems.follows = "systems";
        };
        split-monitor-workspaces = {
            url = "github:Duckonaut/split-monitor-workspaces?rev=d0ba2bb24953c3c35a4a369ae4b4e50cb03f1832";
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
            inputs = {
                nixpkgs.follows = "nixpkgs";
                flake-compat.follows = "flake-compat";
            };
        };
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
        lanzaboote = {
            url = "github:nix-community/lanzaboote";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                flake-compat.follows = "flake-compat";
                flake-parts.follows = "flake-parts";
                pre-commit-hooks-nix.follows = "";
            };
        };
        nix-easyroam = {
            url = "github:0x5a4/nix-easyroam";
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
    };

    outputs = inputs:
        inputs.flake-parts.lib.mkFlake {inherit inputs;} {
            systems = import inputs.systems;
            imports = [
                ./overlays
                ./pkgs
                ./templates
                inputs.pre-commit-hooks.flakeModule
            ];
            flake = {
                lib = inputs.haumea.lib.load {
                    src = ./lib;
                    inputs = {
                        inherit (inputs.nixpkgs) lib;
                    };
                };
                nixosConfigurations = inputs.modulix.lib.mkHosts {
                    inherit inputs;
                    flakePath = "/home/jesse/.dotfiles";
                    modulesPath = ./modules;
                    specialArgs = {
                        hashedPassword = null;
                        hostName = "nixos";
                        isThinClient = false;
                        username = "jesse";
                    };
                    helpers = inputs.home-manager.lib // inputs.self.lib;
                    sharedConfig = {
                        modules.bundles.shared.enable = true;
                    };
                };
            };
            perSystem = {
                config,
                system,
                ...
            }: {
                pre-commit.settings.hooks = {
                    shellcheck = {
                        enable = true;
                        excludes = ["\\.envrc"];
                    };
                    # nix
                    # alejandra.enable = true;
                    statix = {
                        enable = true;
                        package = inputs.statix.packages.${system}.statix;
                    };
                    ripsecrets.enable = true;
                };
                devShells.default = config.pre-commit.devShell;
            };
        };
}
