{
    lib,
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
        keyMode = "vi";
        shortcut = "Space"; # Ctrl+Space
        baseIndex = 1; # window and pane index
        plugins = with pkgs.tmuxPlugins; [
            vim-tmux-navigator
            catppuccin
        ];
        extraConfigBeforePlugins = /*tmux*/''
            source-file $NH_FLAKE/${lib.mkRelativePath ./before.tmux}
        '';
        extraConfig = /*tmux*/''
            source-file $NH_FLAKE/${lib.mkRelativePath ./after.tmux}
        '';
    };

    hm.stylix.targets.tmux.enable = false;
}
