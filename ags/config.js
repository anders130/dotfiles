import { Bar } from './components/MainBar/index.js'

App.config({
    style: './style.css',
    windows: [
        Bar(0),
        Bar(1),
        Bar(2),
    ]
})
