// Generate a list of buttons linked to an application.

import PopupWindow from "widgets/PopupWindow"
import { Application } from 'service/applications'

import { WINDOW_NAME } from './launcher'

import * as ShRun from './ShRun'

const { query } = await Service.import("applications")

// Pack an application into a button
const PackButton = (app: Application) => Widget.Button({
	on_clicked: () => {
		App.closeWindow(WINDOW_NAME)
		app.launch()
	},
	attribute: { app },
	child: Widget.Box({
		children: [
			Widget.Icon({
				icon: app.icon_name || "",
				size: 42,
			}),
			Widget.Label({
				class_name: "title",
				label: app.name,
				xalign: 0,
				vpack: "center",
				truncate: "end",
			}),
		],
	}),
})

// return a list of application buttons
// calling filterApps on this return object will mutate the list
export const Applauncher = (q: string = '') => {
	let apps = query(q || "").map(PackButton)
	// let apps: any[] = []

	// directly modify the array
	function filterApps(s: string = '') {
		apps.length = 0
		apps.push(...query(s || '').map(PackButton))
	}

	return Object.assign(apps, {
		filterApps
	})

	// container holding the buttons
	// const app_button_list = Widget.Box({
	// 	vertical: true,
	// 	children: apps,
	// 	spacing: 12,
	// })

	// return apps

	// // wrap the list in a scrollable
	// const apps = Widget.Scrollable({
	// 	class_name: 'apps',
	// 	hscroll: "never",
	// 	child: app_button_list,
	// })

	// return packed_btn_apps
}

export default Applauncher

// there needs to be only one instance
// export const applauncher = Widget.Window({
// 	name: WINDOW_NAME,
// 	setup: self => self.keybind("Escape", () => {
// 		App.closeWindow(WINDOW_NAME)
// 	}),
// 	visible: false,
// 	keymode: "exclusive",
// 	child: Applauncher({
// 		width: 500,
// 		height: 500,
// 		spacing: 12,
// 	}),
// })


