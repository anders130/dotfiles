{
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

        plugins = with pkgs; [
            tmuxPlugins.sensible
            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.dracula
            tmuxPlugins.yank
        ];

        extraConfig = ''
        # source-file ${config.home.homeDirectory}/.dotfiles/tmux/tmux.conf
# fix colors
set-option -sa terminal-overrides ",xterm*:Tc"

set -g mouse on
set-option -g default-shell $SHELL

# reload config
unbind r
bind r source-file ~/.config/tmux/tmux.conf

# keybinds
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

## act like vim
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

## fix clear console
bind C-l send-keys 'C-l'

## fix directory path to be the current
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# misc
set -g status-position top
# setw -g clock-mode-style 24

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# dracula
set -g @dracula-plugins "time weather"
## time
set -g @dracula-show-timezone false
set -g @dracula-time-format "%R"
## weather
set -g @dracula-fixed-location "Oldenburg"
set -g @dracula-show-fahrenheit false
set -g @dracula-show-location false
## looks
set -g @dracula-show-powerline true # makes tmux bar pointy
set -g @dracula-show-flags true
set -g @dracula-show-left-icon session # show session-id on the left
        '';
    };
}
