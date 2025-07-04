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
                home-manager.follows = "home-manager";
                nixpkgs.follows = "nixpkgs";
                systems.follows = "systems";
                nur.follows = "nur";
                flake-compat.follows = "flake-compat";
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
        nix-melt = {
            url = "github:nix-community/nix-melt";
            inputs.nixpkgs.follows = "nixpkgs";
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
            url = "github:kaylorben/nixcord";
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

        # gui
        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            ref = "refs/tags/v0.49.0";
            submodules = true;
            inputs.systems.follows = "systems";
        };
        split-monitor-workspaces = {
            url = "github:Duckonaut/split-monitor-workspaces";
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
            };
        };
        nix-easyroam = {
            url = "github:0x5a4/nix-easyroam";
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
                ./modules2
                ./overlays
                ./pkgs
                ./templates
            ];
            flake = {
                lib = inputs.haumea.lib.load {
                    src = ./lib;
                    inputs = {
                        inherit (inputs.nixpkgs) lib;
                    };
                };
                # nixosConfigurations = inputs.modulix.lib.mkHosts {
                #     inherit inputs;
                #     flakePath = "/home/jesse/.dotfiles";
                #     modulesPath = ./modules;
                #     specialArgs = {
                #         hashedPassword = null;
                #         hostname = "nixos";
                #         isThinClient = false;
                #         username = "jesse";
                #     };
                #     helpers = inputs.home-manager.lib // inputs.self.lib;
                #     sharedConfig = {
                #         modules.bundles.shared.enable = true;
                #     };
                # };
                nixosConfigurations.test = inputs.nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        # inputs
                        inputs.disko.nixosModules.disko
                        inputs.home-manager.nixosModules.home-manager
                        inputs.stylix.nixosModules.stylix
                        # host specific
                        ./hosts/desktop/hardware-configuration.nix
                        ./hosts/desktop/disk-config.nix
                        # modules
                        inputs.self.nixosModules.default
                        inputs.self.nixosModules.hyprland
                        {
                            boot.loader.systemd-boot.enable = true;
                            users.users.jesse.isNormalUser = true;
                            home-manager.users.jesse = {
                                home.username = "jesse";
                                home.stateVersion = "25.05";
                                imports = [
                                    inputs.self.homeModules.hyprland
                                ];
                            };
                        }
                    ];
                };
            };
        };
}
