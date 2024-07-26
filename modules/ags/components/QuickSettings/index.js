import { Media } from "./widgets/Media.js"

const WINDOW_NAME = "quicksettings"

export const QuickSettings = Widget.Window({
    name: WINDOW_NAME,
    setup: self => self.keybind("Escape", () => {
        App.closeWindow(WINDOW_NAME)
    }),
    visible: false,
    keymode: "exclusive",
    child: Media,
})

App.applyCss(`${App.configDir}/components/QuickSettings/style.css`)
