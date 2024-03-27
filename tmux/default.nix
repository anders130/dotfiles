{
    username,
    pkgs,
    ...
}: {
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
