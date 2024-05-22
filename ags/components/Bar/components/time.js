const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S  -  %e. %b"'],
})

export const SimpleTime = () => Widget.Box({
    css: "padding: 10px; margin-left: -11px",
    children: [
        Widget.Label({
            label: date.bind()
        })
    ]
})

export const Clock = () => Widget.Box({
    children: [
        Widget.Icon("preferences-system-time-symbolic"),
        Widget.Label({
            label: date.bind().as(v => v.split(" - ")[0].trim())
        })
    ]
})

export const Date = () => Widget.Box({
    children: [
        Widget.Icon("x-office-calendar-symbolic"),
        Widget.Label({
            label: date.bind().as(v => v.split(" - ")[1].trim())
        })
    ]
})
