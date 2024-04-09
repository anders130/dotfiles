import { Bar } from './components/MainBar/index.js'

App.config({
    style: './style.css',
    windows: [
        Bar(0),
        Bar(1),
        Bar(2),
    ]
})

// Utils.monitorFile(
//     // directory that contains the scss files
//     `${App.configDir}/components/MainBar`,
//
//     // reload function
//     function() {
//         // main scss file
//         const css = `${App.configDir}/components/MainBar/style.css`
//
//         // compile, reset, apply
//         App.resetCss()
//         App.applyCss(css)
//     },
// )
//
