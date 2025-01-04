const battery = await Service.import('battery')

export const Battery = Widget.Box({
    class_name: 'battery-bar',
    children: [
        Widget.Icon({
            icon: battery.bind('icon_name')
        }),
        Widget.Label({
            label: battery.bind('percent').as((p) => `${p}%`),
            margin: 10
        })
    ],
    visible: battery.bind('available')
})
