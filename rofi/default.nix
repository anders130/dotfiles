{
    lib,
    pkgs,
    username,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            theme = "catppuccin-macchiato";
            terminal = "${pkgs.unstable.alacritty}/bin/alacritty";
        };

        xdg.configFile."rofi/catppuccin-macchiato.rasi" = lib.mkSymlink { config = config; source = "rofi/catppuccin-macchiato.rasi"; };

        xdg.configFile."rofimoji.rc".text = ''
            action = copy
            skin-tone = neutral
            max-recent = 0
        '';
    };
}
