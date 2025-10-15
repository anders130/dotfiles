{
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    options = {
        nix-daemon = {
            enableLimit = lib.mkEnableOption "Enable nix-daemon OOM limits";
            pressure-limit = lib.mkOption {
                type = lib.types.str;
                default = "50%";
                description = "OOM pressure limit for nix-daemon";
            };
        };
    };

    config = cfg: {
        nix = {
            package = pkgs.lixPackageSets.latest.lix;
            gc = {
                automatic = true;
                options = "--delete-older-than 7d";
            };

            registry = {
                custom.flake = inputs.self;
                nixpkgs.flake = inputs.nixpkgs;
                unstable.flake = inputs.nixpkgs-unstable;
            };

            settings = rec {
                accept-flake-config = true;
                auto-optimise-store = true;

                experimental-features = [
                    "nix-command"
                    "flakes"
                    "pipe-operator"
                ];

                trusted-users = [username];

                substituters = [
                    "https://anders130.cachix.org"
                    "https://nix-community.cachix.org"
                    "https://hyprland.cachix.org"
                ];
                trusted-public-keys = [
                    "anders130.cachix.org-1:mCAq0L6Ld3lG7gxJVHGzKr2rqUZ5qs5YoERxoSjMOXs="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                ];
                trusted-substituters = substituters;
            };

            extraOptions = ''
                !include /home/${username}/.nix.conf
            '';
        };

        systemd = lib.mkIf cfg.nix-daemon.enableLimit {
            slices."nix-daemon".sliceConfig = {
                ManagedOOMMemoryPressure = "kill";
                ManagedOOMMemoryPressureLimit = cfg.nix-daemon.pressure-limit;
            };
            services."nix-daemon".serviceConfig = {
                Slice = "nix-daemon.slice";
                OOMScoreAdjust = 1000;
            };
        };
    };
}
