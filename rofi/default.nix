{
    username,
    pkgs,
    home-symlink,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            theme = "custom";
            terminal = "${pkgs.unstable.alacritty}/bin/alacritty";
        };

        xdg.configFile."rofi/custom.rasi" = home-symlink { config = config; source = "rofi/custom.rasi"; };
    };
}
