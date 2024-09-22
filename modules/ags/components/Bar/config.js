import { Bar } from './index.js'
import {
    Volume,
    Speaker,
    Workspaces,
    Battery,
    SysTray,
    SimpleTime
} from './components.js'

export const MainScreenBar = (monitor = 0) =>
    Bar({
        monitor: monitor,
        left: [Workspaces({ monitor: monitor })],
        center: [SimpleTime()],
        right: [SysTray(), Battery, Speaker(), Volume()]
    })

export const SecondaryScreenBar = (monitor = 0) =>
    Bar({
        monitor: monitor,
        left: [Workspaces({ monitor: monitor })],
        center: [SimpleTime()],
        right: [SysTray(), Speaker(), Volume()]
    })
