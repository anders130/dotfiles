{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    options.programs.cli.nix = {
        enable = lib.mkEnableOption "nix";
    };

    config.nix = lib.mkIf config.programs.cli.nix.enable {
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
}
