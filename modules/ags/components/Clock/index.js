import { date } from "../Bar/components/time.js"

const WINDOW_NAME = "clock"
const hyprland = await Service.import("hyprland")

export const Clock = ({ monitor = 0 }) => {
    const monitorWidth = hyprland.getMonitor(monitor)?.width ?? 0
    print(monitorWidth)
    return Widget.Window({
        name: `${WINDOW_NAME}-${monitor}`,
        monitor,
        keymode: "none",
        sensitive: false,
        layer: "background",
        className: "clock-window",
        child: Widget.CenterBox({
            className: `clock ${monitorWidth > 1920
                && "clock-widescreen"}`,
            spacing: 200,
            centerWidget: Widget.Label({
                className: "clock-label",
                label: date.bind().as(d => d.slice(0, 5)),
            }),
        })
    })
}

App.applyCss(`${App.configDir}/components/Clock/style.css`)
