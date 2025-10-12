function project
    function find_projects
        if type -q fd
            fd --full-path --type d --hidden '\.git$' "$HOME/Projects" | sed 's#/.git##' | sed 's#/$##'
        else
            find "$HOME/Projects" -type d -name ".git" -print | sed 's#/.git##' | sed 's#/$##'
        end
    end

    if test -z "$argv[1]"
        if type -q fzf
            set project_dir (find_projects | fzf)
            if test -z "$project_dir"
                echo "No project selected."
                return 1
            end
            set project_name (basename "$project_dir")
        else
            echo "Usage: project <project-name>"
            return 1
        end
    else
        set project_name "$argv[1]"
        set project_dir (find_projects | grep -E '/'$project_name'$' | head -n 1)

        if test -z "$project_dir"
            echo "Project directory matching '$project_name' not found."
            return 1
        end
    end

    set session_name (echo "$project_name" | tr '.' '-')

    echo "Opening project '$project_name' at '$project_dir'..."

    tmux has-session -t "$session_name" 2>/dev/null
    if test $status -ne 0
        tmux new-session -d -s "$session_name" -c "$project_dir"
        tmux rename-window -t "$session_name":1 code
        tmux send-keys -t "$session_name":code 'nvim .' C-m
        tmux new-window -t "$session_name" -n test -c "$project_dir"
        tmux select-window -t "$session_name":code
    end

    if set -q TMUX
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    end
end
