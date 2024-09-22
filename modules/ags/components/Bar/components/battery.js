const battery = await Service.import('battery')

export const Battery = Widget.CircularProgress({
    child: Widget.Icon({
        icon: battery.bind('icon_name')
    }),
    visible: battery.bind('available'),
    value: battery.bind('percent').as((p) => (p > 0 ? p / 100 : 0)),
    class_name: battery.bind('charging').as((ch) => (ch ? 'charging' : ''))
})
