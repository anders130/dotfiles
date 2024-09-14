const hyprland = await Service.import('hyprland')

export const Bar = ({ monitor = 0, left, center, right }) => {
    const activeMonitorId = hyprland.active.monitor.bind('id')

    return Widget.Window({
        name: `bar-${monitor}`,
        class_name: activeMonitorId.as(
            (id) => `bar ${id === monitor ? 'active' : ''}`
        ),
        monitor,
        anchor: ['top', 'left', 'right'],
        exclusivity: 'exclusive',
        margins: [5, 5, 0, 5],
        child: Widget.CenterBox({
            start_widget: Widget.Box({
                spacing: 8,
                hpack: 'start',
                children: left
            }),
            center_widget: Widget.Box({
                spacing: 8,
                children: center
            }),
            end_widget: Widget.Box({
                spacing: 8,
                hpack: 'end',
                children: right
            })
        })
    })
}

App.applyCss(`${App.configDir}/components/Bar/style.css`)
