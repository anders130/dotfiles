{
    config,
    pkgs,
    ...
}: {
    home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tmux/tmux.conf";

    programs.tmux = {
        enable = true;
        # Stop tmux+escape craziness.
        escapeTime = 0;
        # Force tmux to use /tmp for sockets (WSL2 compat)
        secureSocket = false;

        plugins = with pkgs; [
            tmuxPlugins.sensible
            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.dracula
            tmuxPlugins.yank
        ];
    };
}
