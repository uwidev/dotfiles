const hyprland = await Service.import("hyprland")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

const date = Variable("", {
	poll: [1000, 'date "+%I:%M%p"'],
})

const dispatch = wid => hyprland.messageAsync(`dispatch workspace ${wid}`);
const activeId = hyprland.active.workspace.bind("id")

// Alternative method of workspace buttons, but is limited to 10 and does not
// take into account named workspaces
// const Workspaces = (monitor) => Widget.EventBox({
//     class_name: "module workspaces",
//     onScrollUp: () => dispatch('+1'),
//     onScrollDown: () => dispatch('-1'),
//     child: Widget.Box({
//         children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
//             class_name: activeId.as(a => `${a === i ? "focused" : ""}`),
//             attribute: i,
//             label: `${i}`,
//             onClicked: () => dispatch(i),
//         })),
//
//
//         // remove this setup hook if you want fixed number of buttons
//         setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
//             btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute && ws.monitorID === monitor);
//         })),
//     }),
// })

const Workspaces = (monitor) => Widget.EventBox({
	class_name: "module workspaces",
	onScrollUp: () => dispatch('m-1'),
	onScrollDown: () => dispatch('m+1'),
	child: Widget.Box({
		children: hyprland.bind("workspaces")
			.as((ws) => ws
				.filter(ws => ws.id >= 0 && ws.monitorID === monitor)
				.sort((a, b) => a.id - b.id)
				.map(({ id }) =>
					Widget.Button({
						class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
						on_clicked: () => dispatch(id),
						child: Widget.Label(`${id}`)
					})
				)
			)
	})
})

const focusedTitle = () => Widget.Label({
	class_name: "module client-title",
	label: hyprland.active.client.bind(`title`),
	visible: hyprland.active.client.bind(`address`)
		.as(addr => !!addr),
})

//function ClientTitle() {
//    return Widget.Label({
//        class_name: "module client-title",
//        label: hyprland.active.client.bind("title"),
//    })
//}


function Clock() {
	return Widget.Label({
		class_name: "module clock",
		label: date.bind(),
	})
}

//
// // we don't need dunst or any other notification daemon
// // because the Notifications module is a notification daemon itself
// function Notification(monitor) {
//     const popups = notifications.bind("popups")
//     return Widget.Box({
//         class_name: "module notification",
//         visible: popups.as(p => p.length > 0),
//         children: [
//             Widget.Icon({
//                 icon: "preferences-system-notifications-symbolic",
//             }),
//             Widget.Label({
//                 label: popups.as(p => p[0]?.summary || ""),
//             }),
//         ],
//     })
// }

// const popups = notifications.bind('popups')
// const Notification = (media) => Widget.Box({
//     class_name: 'module notification',
//     visible: popups.as(p => p.length > 0),
//     children: [
//         Widget.Icon({
//             icon: 'preferences-system-notifications-symbolic',
//         }),
//         Widget.Label({
//             label: popups.as(p => p[0]?.summary || ''),
//         })
//     ],
// })


// function Media() {
//     const label = Utils.watch("", mpris, "player-changed", () => {
//         if (mpris.players[0]) {
//             const { track_artists, track_title } = mpris.players[0]
//             return `${track_artists.join(", ")} - ${track_title}`
//         } else {
//             return "Nothing is playing"
//         }
//     })

//     return Widget.Button({
//         class_name: "module media",
//         on_primary_click: () => mpris.getPlayer("")?.playPause(),
//         on_scroll_up: () => mpris.getPlayer("")?.next(),
//         on_scroll_down: () => mpris.getPlayer("")?.previous(),
//         child: Widget.Label({ label }),
//     })
// }


function Volume() {
	const icons = {
		101: "overamplified",
		67: "high",
		34: "medium",
		1: "low",
		0: "muted",
	}

	function getIcon() {
		const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
			threshold => threshold <= audio.speaker.volume * 100)

		return `audio-volume-${icons[icon]}-symbolic`
	}

	const icon = Widget.Icon({
		icon: Utils.watch(getIcon(), audio.speaker, getIcon),
	})

	const slider = Widget.Slider({
		hexpand: true,
		draw_value: false,
		on_change: ({ value }) => audio.speaker.volume = value,
		setup: self => self.hook(audio.speaker, () => {
			self.value = audio.speaker.volume || 0
		}),
	})

	return Widget.Box({
		class_name: "module volume",
		css: "min-width: 180px",
		children: [icon, slider],
	})
}

function BatteryClass(c: boolean, p: number): string {
	let base = 'module battery'
	console.log(p)
	if (c) {
		return base.concat(' charging')
	}
	if (p > 15) {
		return base.concat(' charged')
	}
	return base.concat(' low')
}

function BatteryLabel() {
	const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
	const icon = battery.bind("percent").as(p =>
		`battery-level-${Math.floor(p / 10) * 10}-symbolic`)

	return Widget.Box({
		class_name: battery.bind('charging').as(ch => BatteryClass(ch, battery.percent)),
		visible: battery.bind("available"),
		children: [
			Widget.Icon({ icon }),
			Widget.LevelBar({
				widthRequest: 64,
				vpack: "center",
				value,
			}),
		],
	})
}


function SysTray() {
	const items = systemtray.bind("items")
		.as(items => items.map(item => Widget.Button({
			child: Widget.Icon({ icon: item.bind("icon") }),
			on_primary_click: (_, event) => item.activate(event),
			on_secondary_click: (_, event) => item.openMenu(event),
			tooltip_markup: item.bind("tooltip_markup"),
		})))

	return Widget.Box({
		class_name: "module tray",
		children: items,
	})
}


// layout of the bar
function Left(monitor = 0) {
	return Widget.Box({
		spacing: 8,
		children: [
			Workspaces(monitor),
			// Notification(monitor),
		],
	})
}

function Center() {
	return Widget.Box({
		spacing: 8,
		children: [
			focusedTitle(),
		],
	})
}

function Right() {
	return Widget.Box({
		hpack: "end",
		spacing: 8,
		children: [
			//Volume(),
			BatteryLabel(),
			Clock(),
			SysTray(),
		],
	})
}

export function Bar(monitor = 0) {
	return Widget.Window({
		name: `bar-${monitor}`, // name has to be unique
		class_name: "bar",
		monitor,
		anchor: ["top", "left", "right"],
		exclusivity: "exclusive",
		child: Widget.CenterBox({
			start_widget: Left(monitor),
			center_widget: Center(),
			end_widget: Right(),
		}),
	})
}


