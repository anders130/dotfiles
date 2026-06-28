{
    inputs,
    config,
    ...
}: let
    inherit (config.flake.lib) style;
in {
    flake.wrappers.tmux = {
        pkgs,
        lib,
        ...
    }: let
        c = (style.colors pkgs lib).withHashtag;
    in {
        imports = [inputs.wrapper-modules.wrapperModules.tmux];

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
        ];

        configBefore =
            #tmux
            ''
                set-option -g default-shell $SHELL

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
                bind K confirm-before -p "kill #S? (y/n)" "run-shell 'tmux switch-client -l 2>/dev/null; tmux kill-session -t \"#{session_name}\"'"
            '';
        configAfter =
            #tmux
            ''
                set -g status-position top
                set -g status-justify left
                set -g status-style "bg=default,fg=${c.base05}"
                set -g status-left ""
                set -g status-left-length 100
                set -g status-right-length 100

                # windows: " <index> " block + " <command> " block; current accented
                set -g window-status-format "#[fg=${c.base00},bg=${c.base04}] #I #[fg=${c.base05},bg=${c.base01}]#{b:pane_current_command} "
                set -g window-status-current-format "#[fg=${c.base00},bg=${c.base0E}] #I #[fg=${c.base05},bg=${c.base02}]#{b:pane_current_command} "

                # right: session name; accent turns red while the prefix is held
                set -g status-right "#[fg=${c.base00},bg=#{?client_prefix,${c.base08},${c.base0B}}] #[fg=${c.base05},bg=${c.base01}] #S "

                # selection / copy mode
                setw -g mode-style "fg=#f5bde6,bg=${c.base02}"
                set -g clock-mode-colour "${c.base0D}"

                # messages + command prompt
                set -g message-style "fg=${c.base0C},bg=${c.base03}"
                set -g message-command-style "fg=${c.base0C},bg=${c.base03}"

                # pane borders
                set -g pane-border-style "fg=${c.base02}"
                set -g pane-active-border-style "fg=${c.base0D}"
            '';
    };

    den.aspects.tmux.homeManager = {self', ...}: {
        home.packages = [self'.packages.tmux];
    };
}
