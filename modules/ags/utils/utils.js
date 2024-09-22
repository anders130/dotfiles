import Gtk from 'gi://Gtk?version=3.0'
import Gdk from 'gi://Gdk'

/**
 * @param {(monitor: number) => Gtk.Window} widget
 * @returns {Gtk.Window[]}
 */
export function forMonitors(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1
    return range(n, 0).flatMap(widget)
}

/**
 * @param {number} length
 * @param {number} start
 * @returns {number[]}
 */
export function range(length, start = 1) {
    return Array.from({ length }, (_, i) => i + start)
}
