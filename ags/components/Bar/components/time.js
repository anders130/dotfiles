const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S  - %e. %b"'],
})

export const SimpleTime = () => Widget.Box({
    css: "padding: 10px; margin-left: -22px",
    children: [
        Widget.Label({
            label: date.bind()
        })
    ]
})

export const Clock = () => {
    return Widget.Box({
        children: [
            Widget.Icon("preferences-system-time-symbolic"),
            Widget.Label({
                label: date.bind().as(v => v.split(" - ")[0].trim())
            })
        ]
    })
}
export const Date = () => {
    return Widget.Box({
        children: [
            Widget.Icon("x-office-calendar-symbolic"),
            Widget.Label({
                label: date.bind().as(v => v.split(" - ")[1].trim())
            })
        ]
    })
}
