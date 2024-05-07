import { Bar } from "./index.js"
import { Volume, Speaker, Workspaces, Media, Notification, SysTray, Clock, Date } from "./components.js"

export function MainScreenBar({ monitor = 0 }) {
    return Bar({
        monitor: monitor,
        left: [
            Workspaces(),
        ],
        center: [
            Clock(),
            Date(),
            SysTray(),
        ],
        right: [
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
            Workspaces(),
        ],
        center: [
            Clock(),
            Date(),
            SysTray(),
        ],
        right: [
            Media(),
            Speaker(),
            Volume(),
        ]
    });
}
