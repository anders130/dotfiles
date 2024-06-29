# # fix hyprsome monitor workspaces
# hyprctl dispatch movefocus r
# hyprctl dispatch movefocus r
# hyprsome workspace 1
# hyprctl dispatch movefocus l

# only execute if noisetorch is not yet active (grep finds <= 1 results)
if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
    sleep 1 && noisetorch -i
fi

# hardware stuff
xrandr --output DP-2 --primary

# fix ssh agent
if ssh-add -l | grep -q "The agent has no identities."; then
    for key in ~/.ssh/id_*; do
        if [[ -f $key && ! $key =~ \.pub$ ]]; then
            ssh-add "$key"
        fi
    done
else
  echo "SSH agent already has identities loaded."
fi
