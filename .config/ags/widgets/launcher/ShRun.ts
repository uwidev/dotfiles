import icons from "lib/icons"
import sh from "service/sh"

const iconVisible = Variable(false)

const PackButton = (bin: string) => Widget.Button({
    on_clicked: () => {
        Utils.execAsync(bin)
        App.closeWindow("launcher")
    },
    child: Widget.Box({
        children: [
            Widget.Icon({
                icon: icons.app.terminal || "",
                size: 42,
            }),
            Widget.Label({
                class_name: 'title',
                label: bin,
                xalign: 0,
                vpack: 'center',
                truncate: 'end',
            })
        ]
    }),
    class_name: "sh-item",
})

export function Icon() {
    const icon = Widget.Icon({
        icon: icons.app.terminal,
        class_name: "spinner",
    })

    return Widget.Revealer({
        transition: "slide_left",
        child: icon,
        reveal_child: iconVisible.bind(),
    })
}

// async function filter(term: string) {
//     const found = await sh.query(term)
//     list.children = found.map(PackButton)
//     revealer.reveal_child = true
// }

// retrun a list of packed button binaries
export function ShRun(q: string = "''") {
    let bins: any[] = []

    async function filterBins(s: string = "''") {
        const found = await sh.query(s)
        bins.length = 0
        bins.push(...found.map(PackButton))
    }

    return Object.assign(bins, {
        filterBins,
        run: sh.run
    })
}
