import { App } from "astal/gtk3"
import style from "./style/main.scss"
import Applauncher from "./widget/applauncher/Applauncher"
import Init from "./Init"

import monitorStyle from "./cssHotLoad";

monitorStyle;

App.start({
    css: style,
    instanceName: "astal",
    requestHandler(request: string, res: (response: any) => void) {
        if (request == 'launcher') {
            App.toggle_window(Applauncher)
        }
        res("ok")
    },
    main: () => App.get_monitors().map(Init),
})
