import { Application } from "resource:///com/github/Aylur/ags/service/applications.js"
import { getIcons } from "../../../utils/icons.js"

const hyprland = await Service.import("hyprland")

export const Workspaces = ({ monitor = 0 }) => {
    const activeId = hyprland.active.workspace.bind("id")
    const workspaces = hyprland.bind("workspaces").as(ws => ws
        .sort((a, b) => Math.abs(a.id) - Math.abs(b.id))
        .filter(({ id }) => {
            if (id < 0) return true;
            const workspaceMonitor = Math.floor((id - 1) / 10)
            return workspaceMonitor === monitor
        })
        .map(({ id }) => {
            const adjustedId = id < 0
                ? id
                : id % 10
            return Widget.Button({
                on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
                child: Widget.Box({
                    children: [
                        Widget.Label(`${adjustedId}`),
                        Clients(id)
                    ],
                    spacing: 16
                }),
                class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
            })
        })
    )

    return Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })
}

/** @param {Application | undefined} app */
const AppIcon = app => Widget.Icon({
    icon: app?.icon_name || "",
    size: 16,
    class_name: "app-icon"
})

/** @param {number} workspaceId */
export const Clients = workspaceId => {
    const clients = hyprland.bind("clients").as(cs => cs
        .filter(c => c.workspace.id == workspaceId)
        .filter(c => c.class !== "steam" || c.title === "Steam")
        .filter(c => (c.class !== "Google-chrome" || c.initialTitle.includes("Chrome")
            || c.initialTitle === "Microsoft Teams"
            || c.initialTitle === "YouTube Music")
            && c.initialTitle.trim() !== "")
        .map(c => Widget.Box({
            children: [AppIcon(getIcons(c))],
        })))
    return Widget.Box({
        class_name: "clients",
        children: clients,
        spacing: 8
    })
}

export const ClientTitle = () => Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client.bind("title"),
})
