const date = Variable('', {
    poll: [1000, 'date'],
})

const Bar = (monitor = 0) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.Label({ label: date.bind() })
})

App.config({
    windows: [
        Bar(0),
        Bar(1),
        Bar(2),
    ]
})
