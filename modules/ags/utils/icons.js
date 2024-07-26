// import Gtk from 'gi://Gtk?version=3.0';

// const icons = Gtk.IconTheme.get_default().list_icons(null)
// export const iconList = []
//
// icons.forEach(i => {
//     if (i.includes("weather")) {
//         iconList.push(Widget.Button({
//             child: Widget.Icon(i),
//             on_clicked: () => print(i)
//         }))
//     }
// })
import { Application } from "resource:///com/github/Aylur/ags/service/applications.js"
const { query } = await Service.import("applications")

/**
 * @param {import("types/service/hyprland").Client} client
 * @returns {Application | undefined}
 */
export const getIcons = (client) => {
    const likelyApps = query(client.class)
    if (likelyApps.length == 0) {
        return query(client.initialTitle.split(":")[0]).at(0)
    }
    if (likelyApps.length == 1) return likelyApps.at(0)
    return likelyApps.filter(app => client.initialTitle.includes(app.name.trim())).at(0)
}

