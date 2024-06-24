{
    lib,
    pkgs,
    username,
    ...
}: {
    programs.neovim = {
        enable = true;
        package = pkgs.unstable.neovim-unwrapped;
        viAlias = true;
        vimAlias = true;
    };

    environment.systemPackages = with pkgs.unstable; [
        gcc
        gnumake
        go
        lua
        nixd
        nodejs_22
        ripgrep
        rustup
    ];

    home-manager.users.${username} = { config, ... }: {
        home.sessionVariables.EDITOR = "nvim";

        xdg.configFile.nvim = lib.mkSymlink {
            config = config;
            source = "neovim";
            recursive = true;
        };
    };
}
