const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S|%b %e."'],
})

export const Clock = () => {
    return Widget.Box({
        children: [
            Widget.Icon("preferences-system-time-symbolic"),
            Widget.Label({
                label: date.bind().as(v => v.split("|")[0])
            })
        ]
    })
}
export const Date = () => {
    return Widget.Box({
        children: [
            Widget.Icon("x-office-calendar-symbolic"),
            Widget.Label({
                label: date.bind().as(v => v.split("|")[1])
            })
        ]
    })
}
