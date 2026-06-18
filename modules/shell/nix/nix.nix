{inputs, ...}: {
    perSystem.rootReadme.usage = [
        {
            title = "Flake update tokens";
            content = ''
                To avoid GitHub rate limits when updating flake inputs, add a token to `~/.nix.conf` (included automatically when present):

                ```conf
                access-tokens = github.com=ghp_***
                ```
            '';
        }
    ];

    den.aspects.nix.nixos = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) mkEnableOption mkIf mkOption types;
    in {
        options.my.nix.daemon = {
            enableLimit = mkEnableOption "nix-daemon OOM limits";
            pressureLimit = mkOption {
                type = types.str;
                default = "50%";
                description = "OOM pressure limit for nix-daemon";
            };
        };
        config = {
            nix = {
                package = pkgs.lixPackageSets.latest.lix;
                gc = {
                    automatic = true;
                    options = "--delete-older-than 7d";
                };
                registry = {
                    custom.flake = inputs.self;
                    nixpkgs.flake = inputs.nixpkgs;
                };
                settings = rec {
                    accept-flake-config = true;
                    auto-optimise-store = true;
                    warn-dirty = false;
                    keep-outputs = true; # nice for development
                    experimental-features = [
                        "nix-command"
                        "flakes"
                        "pipe-operator"
                    ];
                    trusted-users = ["root" "@wheel"];
                    substituters = [
                        "https://anders130.cachix.org"
                        "https://nix-community.cachix.org"
                    ];
                    trusted-public-keys = [
                        "anders130.cachix.org-1:mCAq0L6Ld3lG7gxJVHGzKr2rqUZ5qs5YoERxoSjMOXs="
                        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    ];
                    trusted-substituters = substituters;
                };
                extraOptions = lib.concatMapStrings (u: "!include /home/${u}/.nix.conf\n") config.users.normalUsers;
            };
            programs.nh.enable = true;
            systemd = mkIf config.my.nix.daemon.enableLimit {
                slices."nix-daemon".sliceConfig = {
                    ManagedOOMMemoryPressure = "kill";
                    ManagedOOMMemoryPressureLimit = config.my.nix.daemon.pressureLimit;
                };
                services."nix-daemon".serviceConfig = {
                    Slice = "nix-daemon.slice";
                    OOMScoreAdjust = 1000;
                };
            };
        };
    };
}
