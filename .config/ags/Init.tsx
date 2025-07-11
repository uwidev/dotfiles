import { App } from "astal/gtk3"
import style from "./style/main.scss"
import Bar from "./widget/Bar"
import NotificationPopups from "./widget/notifications/NotificationPopups"
import Applauncher from "./widget/applauncher/Applauncher"
".widget/applauncher/Applauncher"


export default function Init(gdkmonitor: Gdk.Monitor) {
    Bar(gdkmonitor);
    NotificationPopups(gdkmonitor);
    Applauncher()
}
