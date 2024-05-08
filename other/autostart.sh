# only execute if noisetorch is not yet active (grep finds <= 1 results)
if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
    sleep 1 && noisetorch -i
fi

pkill tmux
