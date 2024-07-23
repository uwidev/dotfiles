// random but useful utilities to be shared across windows

import { Application } from 'types/service/applications'

// run app or command in shell
//
// also increment app frequency
export function launchApp(app: Application) {
    const exe = app.executable
        .split(/\s+/)
        .filter(str => !str.startsWith('%') && !str.startsWith('@'))
        .join(' ')

    bash(`${exe} &`)
    app.frequency++
}

// run string in bash
export async function bash(strings: TemplateStringsArray | string, ...values: unknown[]) {
    const cmd = typeof strings === "string" ? strings : strings
        .flatMap((str, i) => str + `${values[i] ?? ""}`)
        .join("")

    return Utils.execAsync(["bash", "-c", cmd]).catch(err => {
        console.error(cmd, err)
        return ""
    })
}

// run a raw command
export async function sh(cmd: string | string[]) {
    return Utils.execAsync(cmd).catch(err => {
        console.error(typeof cmd === "string" ? cmd : cmd.join(" "), err)
        return ""
    })
}

// ensure dependencies exist
export function dependencies(...bins: string[]) {
    const missing = bins.filter(bin => Utils.exec({
        cmd: `which ${bin}`,
        out: () => false,
        err: () => true,
    }))

    if (missing.length > 0) {
        console.warn(Error(`missing dependencies: ${missing.join(", ")}`))
        Utils.notify(`missing dependencies: ${missing.join(", ")}`)
    }

    return missing.length === 0
}
