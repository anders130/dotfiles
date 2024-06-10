function edit-config
    if not eval "tmux has-session -t dotfiles"
        eval "tmux new -d -s dotfiles"
        eval "tmux send-keys -t dotfiles.1 'cd ~/.dotfiles' ENTER"
        eval "tmux send-keys -t dotfiles.1 'nvim .' ENTER"
    end
    eval "tmux a -t dotfiles"
end

