import { QuickSettings } from "./components/QuickSettings/index.js"
import { MainScreenBar, SecondaryScreenBar } from "./components/Bar/config.js"

App.config({
    style: "./style.css",
    windows: [
        SecondaryScreenBar({
            monitor: 0
        }),
        MainScreenBar({
            monitor: 1
        }),
        SecondaryScreenBar({
            monitor: 2
        }),
        QuickSettings,
    ]
})
