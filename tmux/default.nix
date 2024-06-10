{
    pkgs,
    self,
    ...
}: {
    programs.tmux = {
        enable = true;
        # Stop tmux+escape craziness.
        escapeTime = 0;
        # Force tmux to use /tmp for sockets (WSL2 compat)
        secureSocket = false;
        clock24 = true;
        keyMode = "vi";
        shortcut = "Space"; # Ctrl+Space
        baseIndex = 1; # window and pane index
        newSession = true; # if failing tmux a, create new session

        plugins = with pkgs.unstable.tmuxPlugins; [
            # sensible
            vim-tmux-navigator
            catppuccin
            # yank
        ];

        extraConfigBeforePlugins = ''
        source-file ${self}/tmux/tmux.conf
        '';
    };
}
