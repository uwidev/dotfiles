import { App } from "astal/gtk3"
import style from "./style/main.scss"
import Bar from "./widget/Bar"
import NotificationPopups from "./widget/notifications/NotificationPopups"


export default function Init(gdkmonitor: Gdk.Monitor) {
    Bar(gdkmonitor);
    NotificationPopups(gdkmonitor);
}
