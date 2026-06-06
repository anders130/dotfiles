{inputs, ...}: {
    den.aspects.tmux.homeManager = {
        pkgs,
        lib,
        config,
        ...
    }: {
        options.my.tmux.extraConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Extra tmux config appended after the base config; aspects that include tmux add their own keybinds here.";
        };
        config.home.packages = [
            (inputs.wrapper-modules.wrappers.tmux.wrap {
                inherit pkgs;

                # behaviour
                mouse = true;
                escapeTime = 0;
                secureSocket = false;
                allowPassthrough = true;
                updateEnvironment = ["TERM" "TERM_PROGRAM"];

                # ui
                clock24 = true;
                terminal = "tmux-256color";
                baseIndex = 1;

                # keys
                modeKeys = "vi";
                prefix = "C-Space";

                plugins = with pkgs.tmuxPlugins; [
                    vim-tmux-navigator
                    catppuccin
                ];

                configBefore =
                    #tmux
                    ''
                        set-option -g default-shell $SHELL

                        # catppuccin
                        set -g @catppuccin_flavor "macchiato"
                        set -g status-right-length 100
                        set -g status-left-length 100
                        set -g status-left ""
                        set -g status-right ""
                        set -ag status-right "#{E:@catppuccin_status_session}"
                        set -g @catppuccin_window_status_style "basic"
                        set -g @catppuccin_window_text "#{b:pane_current_command}"
                        set -g @catppuccin_window_current_text "#{b:pane_current_command}"

                        # keybindings
                        bind C-Space last-window
                        bind-key y copy-mode
                        bind-key -T copy-mode-vi v send-keys -X begin-selection
                        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                        bind-key -T copy-mode-vi C-q send-keys -X rectangle-toggle
                        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
                        bind C-l send-keys 'C-l'
                        bind c new-window -c "#{pane_current_path}"
                        bind '"' split-window -v -c "#{pane_current_path}"
                        bind % split-window -h -c "#{pane_current_path}"
                        bind S command-prompt -p "New Session:" "new-session -s '%%'"
                        bind K confirm kill-session

                        set -g status-position top
                    '';
                configAfter =
                    #tmux
                    ''
                        set -g status-style bg=default
                        setw -g mode-style "fg=#f5bde6,bg=#494d64"
                    ''
                    + config.my.tmux.extraConfig;
            })
        ];
    };
}
