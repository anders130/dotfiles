import { Stream } from "resource:///com/github/Aylur/ags/service/audio.js"

const audio = await Service.import("audio")

export const Volume = () => {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    const getIcon = () => {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Button({
        child: Widget.Icon({
            icon: Utils.watch(getIcon(), audio.speaker, getIcon),
        }),
        onClicked: () => audio.speaker.is_muted = !audio.speaker.is_muted
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => {
            if (audio.speaker.is_muted && value != 0)
                audio.speaker.is_muted = false
            audio.speaker.volume = value
        },
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "volume",
        css: "min-width: 180px",
        children: [icon, slider],
    })
}

export const Speaker = () => {
    /**
     * @param {Stream} stream
     * @returns {boolean}
     */
    const isHeadPhone = (stream) => stream.name?.includes("Alesis_iO_2") ?? false;

    /**
     * @param {Stream} stream
     * @returns {string}
     */
    const getSpeakerName = (stream) => {
        return isHeadPhone(stream) ? "Headphones" : "Speakers"
    }

    const activeSpeaker = () => Widget.Label()
        .hook(audio.speaker, self => {
            self.set_text(getSpeakerName(audio.speaker))
        })

    return Widget.Button({
        child: activeSpeaker(),
        onClicked: () => {
            if (audio.speaker.id == audio.speakers[0].id)
                audio.speaker = audio.speakers[1]
            else
                audio.speaker = audio.speakers[0]
        }
    })
}
