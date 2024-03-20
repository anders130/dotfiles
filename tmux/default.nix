{
    username,
    config,
    pkgs,
    ...
}: {
    # home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tmux/tmux.conf";

    programs.tmux = {
        enable = true;
        # Stop tmux+escape craziness.
        escapeTime = 0;
        # Force tmux to use /tmp for sockets (WSL2 compat)
        secureSocket = false;
        clock24 = true;

        plugins = with pkgs.tmuxPlugins; [
            sensible
            vim-tmux-navigator
            dracula
            yank
        ];

        extraConfigBeforePlugins = ''
        source-file /home/${username}/.dotfiles/tmux/tmux.conf
        '';
    };
}
