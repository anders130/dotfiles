import { QuickSettings } from "./components/QuickSettings/index.js"
import { Clock } from "./components/Clock/index.js"
import { NotificationPopups } from "./components/NotificationPopups/index.js"
import { MainScreenBar, SecondaryScreenBar } from "./components/Bar/config.js"

App.config({
    style: "./style.css",
    windows: [
        MainScreenBar({
            monitor: 0
        }),
        SecondaryScreenBar({
            monitor: 1
        }),
        SecondaryScreenBar({
            monitor: 2
        }),
        QuickSettings,
        Clock({ monitor: 0 }),
        Clock({ monitor: 1 }),
        Clock({ monitor: 2 }),
        NotificationPopups({
            monitor: 0,
            notificationSound: `${App.configDir}/components/NotificationPopups/sound.mp3`,
        }),
    ]
})
