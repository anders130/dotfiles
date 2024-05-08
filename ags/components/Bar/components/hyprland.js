const hyprland = await Service.import("hyprland")

export function Workspaces({ monitor = 0 }) {
    const activeId = hyprland.active.workspace.bind("id")
    const workspaces = hyprland.bind("workspaces")
        .as(ws => ws.sort((a, b) => {
            return Math.abs(a.id) - Math.abs(b.id)
        })
            .filter(ws => {
                if (ws.id < 0) return true;
                const workspaceMonitor = Math.floor((ws.id - 1) / 10)
                return workspaceMonitor === monitor
            })
            .map(({ id }) => {
                const adjustedId = id < 0
                    ? id
                    : id % 10 || 10;
                return Widget.Button({
                    on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
                    child: Widget.Label(`${adjustedId}`),
                    class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
                })
            }))

    return Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })
}

export function ClientTitle() {
    return Widget.Label({
        class_name: "client-title",
        label: hyprland.active.client.bind("title"),
    })
}
