export const Bar = ({
    monitor = 0,
    left,
    center,
    right
}) => Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        start_widget: Widget.Box({
            spacing: 8,
            hpack: "start",
            children: left,
        }),
        center_widget: Widget.Box({
            spacing: 8,
            children: center,
        }),
        end_widget: Widget.Box({
            spacing: 8,
            hpack: "end",
            children: right,
        }),
    }),
})

App.applyCss(`${App.configDir}/components/Bar/style.css`)
