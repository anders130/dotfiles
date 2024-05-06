import Gtk from 'gi://Gtk?version=3.0';

const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S|%b %e."'],
})

const icons = Gtk.IconTheme.get_default().list_icons(null)
export const iconList = []
icons.forEach(i => {
    if (i.includes("weather")) {
        iconList.push(Widget.Button({
            child: Widget.Icon(i),
            on_clicked: () => print(i)
        }))
    }
})
export const MyClock = () => {
    return Widget.Box({
        children: [
            Widget.Icon("preferences-system-time-symbolic"),
            Widget.Label({
                label: date.bind().as(v => v.split("|")[0])
            }),
            // Widget.Box({
            //     children: iconList
            // })
        ]
    })
}
export const MyDate = () => {
    return Widget.Box({
        children: [
            Widget.Icon("x-office-calendar-symbolic"),
            Widget.Label({
                label: date.bind().as(v => v.split("|")[1])
            })
        ]
    })
}
