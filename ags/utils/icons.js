import Gtk from 'gi://Gtk?version=3.0';

const icons = Gtk.IconTheme.get_default().list_icons(null)
export const iconList = []

icons.forEach(i => {
    if (i.includes("weather")) {
        iconList.push(Widget.Button({
            child: Widget.Icon(i),
            on_clicked: () => print(i)
        }))
    }
})
