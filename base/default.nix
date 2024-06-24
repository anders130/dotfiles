{
    lib,
    username,
    ...
}: {
    imports = [
        ../neovim
        ../tmux

        ./packages.nix
        ./localization.nix
    ];

    networking = {
        networkmanager.enable = lib.mkDefault true;
    };

    users.users.${username} = {
        extraGroups = [
            "networkmanager"
        ];
    };

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;

    programs.direnv.enable = true;
}
