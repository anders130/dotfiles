# Options to make tmux more pleasant
set -g mouse on
set -g default-terminal "tmux-256color"
set-option -g default-shell $SHELL

# Configure the catppuccin plugin
set -g @catppuccin_flavor "macchiato"

## Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right ""
set -ag status-right "#{E:@catppuccin_status_session}"

set -g @catppuccin_window_status_style "basic"
set -g @catppuccin_window_text "#{b:pane_current_command}"
set -g @catppuccin_window_current_text "#{b:pane_current_command}"

# Keybindings and actions
## Reload config
unbind r
bind r source-file /etc/tmux.conf
## copy mode
bind-key y copy-mode
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi C-q send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
## fix clear console
bind C-l send-keys 'C-l'
## fix directory path to be the current
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
## create and kill tmux sessions
bind S command-prompt -p "New Session:" "new-session -s '%%'"
bind K confirm kill-session

# General configuration
set -g status-position top

set -g allow-passthrough on

set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
