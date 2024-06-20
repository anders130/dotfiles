# fix hyprsome monitor workspaces
hyprctl dispatch movefocus r
hyprctl dispatch movefocus r
hyprsome workspace 1
hyprctl dispatch movefocus l

# only execute if noisetorch is not yet active (grep finds <= 1 results)
if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
    sleep 1 && noisetorch -i
fi

pkill tmux
