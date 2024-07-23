import * as Applauncher from "./applauncher"
import * as ShRun from "./ShRun"
import sh from "service/sh"
import PopupWindow from "widgets/PopupWindow"
export const WINDOW_NAME = "launcher"

// import { Variable } from "resource:///com/github/Aylur/ags/variable.js"

const Launcher = () => {
    const apps = Applauncher.Applauncher()

    const container = Widget.Box({
        vertical: true,
        spacing: 12,
        children: apps
    })

    const scrollable = Widget.Scrollable({
        class_name: 'apps',
        hscroll: 'never',
        child: container
    })

    // compose search entry and add functionality
    const l_input = Widget.Entry({
        class_name: 'entry',
        hexpand: true,
        on_accept: ({ text }) => {
            if (text?.startsWith('>')) {
                let cmd = text.substring(1).trim()
                sh.run(cmd)
            }
            else {
                // make sure we only consider visible (searched for) applications
                // if (container.children.length) {
                // container.children[0].attribute.app.launch()
                // }
                const results = apps.filter((item) => item.visible);
                if (results[0]) {
                    results[0].attribute.app.launch()
                }
            }
            App.toggleWindow(WINDOW_NAME)
        },

        // filter out the list
        on_change: ({ text }) => {
            if (text) {
                print(container.children)
                scrollable.visible = true
                container.children.forEach(item => {
                    item.visible = item.attribute.app.match(text ?? "")
                })
            } else {
                scrollable.visible = false
            }
        }
    })
    // on_change: ({ text }) => {
    //     if (text) {
    //         scrollable.visible = true
    //         apps.filterApps(text)
    //         container.children = apps
    //     } else {
    //         scrollable.visible = false
    //     }
    // }


    // build the final launcher
    return Widget.Box({
        class_name: 'launcher',
        vertical: true,
        // css: `margin: ${spacing * 2}px;`,
        children: [
            l_input,
            scrollable,
        ],
        setup: self => self.hook(App, (_, windowName, visible) => {
            if (windowName !== WINDOW_NAME)
                return

            // when the applauncher shows up
            if (visible) {
                container.children = apps
                l_input.text = ""
                l_input.grab_focus()
                scrollable.visible = false
            }
        }, 'window-toggled'),
    })
}

// let foo = await sh.query("''")
// print(`TOP LEVEL QUERY: ${foo}`)

export default () => PopupWindow({
    name: WINDOW_NAME,
    layout: 'top-center',
    child: Launcher()
})
