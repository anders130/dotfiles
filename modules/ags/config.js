import { QuickSettings } from './components/QuickSettings/index.js'
import { Clock } from './components/Clock/index.js'
import { NotificationPopups } from './components/NotificationPopups/index.js'
import { MainScreenBar } from './components/Bar/config.js'
import { forMonitors } from './utils/utils.js'

App.config({
    style: './style.css',
    windows: [
        ...forMonitors(MainScreenBar),
        ...forMonitors(Clock),
        QuickSettings
    ]
})
