import GLib from "gi://GLib"

const main = `${Utils.CACHE_DIR}/main.js`
const entry = `${App.configDir}/main.ts`

try {
    await Utils.execAsync([
        "bun", "build", entry,
        "--outfile", main,
        "--external", "file://*",
        '--external', 'gi://*',
        '--external', 'resource://*',
    ])

    await import(`file://${main}`)
}
catch (err) {
    console.error(err)
    App.quit()
}

export { }
