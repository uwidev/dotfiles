import { App } from "astal/gtk3"
import style from "./style/main.scss"
import Bar from "./widget/Bar"

import monitorStyle from "./cssHotLoad";

monitorStyle;

App.start({
    css: style,
    instanceName: "astal",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(Bar),
})
