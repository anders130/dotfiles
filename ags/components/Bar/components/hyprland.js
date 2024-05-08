const { query } = await Service.import("applications")
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
                    child: Widget.Box({
                        children: [
                            Widget.Label(`${adjustedId}`),
                            Clients(id)
                        ],
                        spacing: 16
                    })
                    ,
                    class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
                })
            }))

    return Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })
}

const AppIcon = app => Widget.Icon({
    icon: app.icon_name || "",
    size: 16,
})

const getIcons = (client) => {
    const likelyApps = query(client.class)
    if (likelyApps.length == 1) return likelyApps.at(0)
    return likelyApps.filter(app => client.initialTitle.includes(app.name.trim())).at(0)
}

export function Clients(workspaceId) {
    const clients = hyprland.bind("clients").as(cs => cs
        .filter(c => c.workspace.id == workspaceId)
        .map(c => {
            return Widget.Box({
                children: [AppIcon(getIcons(c))]
            })
        }))
    return Widget.Box({
        class_name: "clients",
        children: clients,
        spacing: 8
    })
}

export function ClientTitle() {
    return Widget.Label({
        class_name: "client-title",
        label: hyprland.active.client.bind("title"),
    })
}
