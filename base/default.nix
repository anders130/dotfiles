{
    lib,
    username,
    ...
}: {
    imports = [
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

    home-manager.users.${username} = {
        imports = [
            ./home.nix
        ];
    };

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;

    programs.direnv.enable = true;
}
