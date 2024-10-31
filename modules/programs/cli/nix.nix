{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.programs.cli.nix;
in {
    options.programs.cli.nix = {
        enable = lib.mkEnableOption "nix";
        limitNixDaemon = lib.mkEnableOption "limit nix-daemon";
    };

    config = lib.mkIf cfg.enable {
        nix = {
            gc = {
                automatic = true;
                options = "--delete-older-than 7d";
            };

            package = pkgs.nixFlakes;

            registry = {
                custom.flake = inputs.self;
                nixpkgs.flake = inputs.nixpkgs;
                nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
            };

            settings = {
                accept-flake-config = true;
                auto-optimise-store = true;

                experimental-features = [
                    "nix-command"
                    "flakes"
                ];

                trusted-users = [username];
            };

            extraOptions = ''
                !include /home/${username}/.nix.conf
            '';
        };

        systemd = lib.mkIf cfg.limitNixDaemon {
            slices."nix-daemon".sliceConfig = {
                ManagedOOMMemoryPressure = "kill";
                ManagedOOMMemoryPressureLimit = "50%";
            };
            services."nix-daemon".serviceConfig = {
                Slice = "nix-daemon.slice";
                OOMScoreAdjust = 1000;
            };
        };
    };
}
