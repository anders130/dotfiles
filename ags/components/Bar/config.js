import { Bar } from "./index.js"
import { Volume, Speaker, Workspaces, Media, Notification, SysTray, SimpleTime, Clients } from "./components.js"

export function MainScreenBar({ monitor = 0 }) {
    return Bar({
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
            Media(),
            Speaker(),
            Volume(),
        ]
    });
}
export function SecondaryScreenBar({ monitor = 0 }) {
    return Bar({
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
            Media(),
            Speaker(),
            Volume(),
        ]
    });
}
