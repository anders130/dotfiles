{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: lib.mkModule config ./nix.nix {
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
            ];

            trusted-users = [username];
        };

        extraOptions = ''
            !include /home/${username}/.nix.conf
        '';
    };
}
