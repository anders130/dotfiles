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
            gc = {
                automatic = true;
                options = "--delete-older-than 7d";
            };

            package = pkgs.nixVersions.stable;

            registry = {
                custom.flake = inputs.self;
                nixpkgs.flake = inputs.nixpkgs;
            };

            settings = {
                accept-flake-config = true;
                auto-optimise-store = true;

                experimental-features = [
                    "nix-command"
                    "flakes"
                    "pipe-operators"
                ];

                trusted-users = [username];
            };

            extraOptions = ''
                !include /home/${username}/.nix.conf
            '';
        };

        systemd = lib.mkIf cfg.enableLimit {
            slices."nix-daemon".sliceConfig = {
                ManagedOOMMemoryPressure = "kill";
                ManagedOOMMemoryPressureLimit = cfg.pressure-limit;
            };
            services."nix-daemon".serviceConfig = {
                Slice = "nix-daemon.slice";
                OOMScoreAdjust = 1000;
            };
        };
    };
}
