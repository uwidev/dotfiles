import { App } from "astal/gtk3"
import style from "./style/main.scss"
import Init from "./Init.tsx"

import monitorStyle from "./cssHotLoad";

monitorStyle;

App.start({
    css: style,
    instanceName: "astal",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(Init),
})
