const activePort = Variable('Unknown')

export const Speaker = () => {
    const icons = {
        headphones: 'audio-headphones-symbolic',
        speakers: 'audio-speakers-symbolic',
        unknown: 'dialog-question-symbolic'
    }

    const icon = Widget.Icon({ icon: icons.unknown })

    const updateActivePort = () => {
        const result = Utils.exec('pactl list sinks')
        const activePortMatch = result.match(/Active Port:\s+(\S+)/)
        const port = activePortMatch ? activePortMatch[1] : 'Unknown'

        activePort.setValue(port)
    }

    const refreshIcon = () => {
        const port = activePort.value
        icon.icon = port.includes('headphones')
            ? icons.headphones
            : port.includes('lineout') || port.includes('speakers')
              ? icons.speakers
              : icons.unknown
    }

    const togglePort = () => {
        const isHeadPhones = activePort.value.includes('headphones')
        const command = `pactl set-sink-port 0 analog-output-${isHeadPhones ? 'lineout' : 'headphones'}`

        Utils.exec(command)
        updateActivePort()
    }

    activePort.connect('changed', refreshIcon)
    updateActivePort()

    return Widget.Button({
        child: icon,
        onClicked: () => togglePort(),
        tooltipText: activePort.value.includes('headphones')
            ? 'Switch to Speakers'
            : 'Switch to Headphones'
    })
}
