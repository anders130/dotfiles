const audio = await Service.import('audio')

export const Volume = () => {
    const icons = {
        101: 'overamplified',
        67: 'high',
        34: 'medium',
        1: 'low',
        0: 'muted'
    }

    const getIcon = () => {
        const icon = audio.speaker.is_muted
            ? 0
            : [101, 67, 34, 1, 0].find(
                  (threshold) => threshold <= audio.speaker.volume * 100
              )

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Button({
        child: Widget.Icon({
            icon: Utils.watch(getIcon(), audio.speaker, getIcon)
        }),
        onClicked: () => (audio.speaker.is_muted = !audio.speaker.is_muted)
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => {
            if (audio.speaker.is_muted && value != 0)
                audio.speaker.is_muted = false
            audio.speaker.volume = value
        },
        setup: (self) =>
            self.hook(audio.speaker, () => {
                self.value = audio.speaker.volume || 0
            })
    })

    return Widget.Box({
        class_name: 'volume',
        css: 'min-width: 180px',
        children: [icon, slider]
    })
}

export const Speaker = () => {
    const label = Widget.Label({ label: 'Loading...' })

    const getActivePort = () => {
        const result = Utils.exec('pactl list sinks')
        console.log('getActivePort', result)
        const activePortMatch = result.match(/Active Port:\s+(\S+)/) // Match the active port line
        return activePortMatch ? activePortMatch[1] : 'Unknown'
    }

    const updateLabel = () => {
        const activePort = getActivePort()
        if (activePort.includes('headphones')) {
            label.label = 'Headphones'
        } else if (activePort.includes('lineout')) {
            label.label = 'Speakers'
        } else {
            label.label = activePort
        }
    }

    const togglePort = () => {
        const activePort = getActivePort()
        console.log('activePort', activePort)
        const command = activePort.includes('headphones')
            ? 'pactl set-sink-port 0 analog-output-lineout' // Switch to speakers
            : 'pactl set-sink-port 0 analog-output-headphones' // Switch to headphones

        const result = Utils.exec(command)
        console.log('result', result)
        updateLabel()
    }

    updateLabel()

    return Widget.Button({
        child: label,
        onClicked: () => togglePort()
    })
}
