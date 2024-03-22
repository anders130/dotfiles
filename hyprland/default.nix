{
    username,
    ...
}: {
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    home-manager.users.${username} = { config, ... }: {
        xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland/hyprland.conf";
    };
}
