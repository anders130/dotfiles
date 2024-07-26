import { Bar } from "./index.js"
import { Volume, Speaker, Workspaces, Notification, SysTray, SimpleTime } from "./components.js"

export const MainScreenBar = ({ monitor = 0 }) => Bar({
    monitor: monitor,
    left: [
        Workspaces({ monitor: monitor }),
    ],
    center: [
        Notification(),
        SimpleTime(),
    ],
    right: [
        SysTray(),
        Speaker(),
        Volume(),
    ]
})

export const SecondaryScreenBar = ({ monitor = 0 }) => Bar({
    monitor: monitor,
    left: [
        Workspaces({ monitor: monitor }),
    ],
    center: [
        Notification(),
        SimpleTime(),
    ],
    right: [
        SysTray(),
        Speaker(),
        Volume(),
    ]
})
