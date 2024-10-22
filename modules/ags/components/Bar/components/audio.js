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

const activePort = Variable('Unknown')

export const Speaker = () => {
    const label = Widget.Label({ label: 'Loading...' })

    const updateActivePort = () => {
        // fetch new active port value
        const result = Utils.exec('pactl list sinks')
        const activePortMatch = result.match(/Active Port:\s+(\S+)/) // Match the active port line
        const port = activePortMatch ? activePortMatch[1] : 'Unknown'
        // update variable
        activePort.setValue(port)
    }

    const refreshLabel = () => {
        label.label = activePort.value.includes('headphones')
            ? 'Headphones'
            : 'Speakers'
    }

    const togglePort = () => {
        const isHeadPhones = activePort.value.includes('headphones')
        const command = `pactl set-sink-port 0 analog-output-${isHeadPhones ? 'lineout' : 'headphones'}`

        Utils.exec(command)
        updateActivePort()
    }

    activePort.connect('changed', refreshLabel)
    updateActivePort()

    return Widget.Button({
        child: label,
        onClicked: () => togglePort()
    })
}
