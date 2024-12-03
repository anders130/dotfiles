{
    host,
    lib,
    username,
    ...
}: {
    environment.variables = {
        NIX_FLAKE_DEFAULT_HOST = host.name;
        FLAKE = "/home/${username}/.dotfiles";
    };

    modules = {
        console = {
            fish.enable = lib.mkDefault true;
            git.enable = lib.mkDefault true;
            btop.enable = lib.mkDefault true;
            nix.enable = lib.mkDefault true;
            ssh.enable = lib.mkDefault true;
            nvix.enable = lib.mkDefault true;
        };
        services.docker.enable = lib.mkDefault true;
        utils = {
            sops.enable = lib.mkDefault true;
            stylix.enable = lib.mkDefault true;
            home-manager.enable = lib.mkDefault true;
            keyboard.enable = lib.mkDefault true;
            locale.enable = lib.mkDefault true;
            networking.enable = lib.mkDefault true;
            nixpkgs.enable = lib.mkDefault true;
            users.enable = lib.mkDefault true;
        };
    };
}
