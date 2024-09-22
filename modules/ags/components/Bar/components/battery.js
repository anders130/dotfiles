const battery = await Service.import('battery')

const Indicator = Widget.Icon({
    icon: battery.bind('icon_name')
})

const LevelBar = Widget.LevelBar({
    barMode: 'discrete',
    maxValue: 7,
    value: battery.bind('percent').as((p) => (p / 100) * 7),
    margin: 10
})

export const Battery = Widget.Box({
    class_name: 'battery-bar',
    children: [Indicator, LevelBar],
    tooltipText: battery.bind('percent').as((p) => `${p}%`),
    visible: battery.bind('available')
})
