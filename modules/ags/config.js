import { QuickSettings } from "./components/QuickSettings/index.js"
import { Clock } from "./components/Clock/index.js"
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
        Clock({
            monitor: 0
        }),
        Clock({
            monitor: 1
        }),
        Clock({
            monitor: 2
        }),
    ]
})
