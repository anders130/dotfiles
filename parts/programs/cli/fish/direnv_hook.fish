function direnv_hook --on-event fish_prompt
    # Add completions from current PATH
    for p in $PATH
        set completions_dir (dirname $p)/share/fish/vendor_completions.d
        if test -d $completions_dir
            if not contains $completions_dir $fish_complete_path
                set -gx fish_complete_path $fish_complete_path $completions_dir
            end
        end
    end
end

if type -q direnv
    eval (direnv export fish)
end
