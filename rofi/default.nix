{
    username,
    pkgs,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            theme = "custom";
            terminal = "${pkgs.unstable.alacritty}/bin/alacritty";
        };

        xdg.configFile."./rofi/custom.rasi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/rofi/custom.rasi";
    };
}
