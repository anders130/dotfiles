hyprctl dispatch movefocus r

# only execute if noisetorch is not yet active (grep finds <= 1 results)
if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
    sleep 1 && noisetorch -i
fi

# hardware stuff
xrandr --output DP-1 --primary

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
