async function resetCss() {
    print('reloading css')

    // primary source
    const scss = `${App.configDir}/style/main.scss`

    // target
    const css = `${Utils.CACHE_DIR}/style.css`

    // compile scss -> css
    Utils.exec(`sass ${scss} ${css}`)

    App.resetCss()
    App.applyCss(css)
}

Utils.monitorFile(`${App.configDir}/style`, resetCss)
await resetCss()
