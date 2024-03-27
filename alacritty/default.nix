{
    username,
    home-symlink,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile."alacritty/alacritty.toml" = home-symlink { config = config; source = "alacritty/alacritty.toml"; };
    };
}
